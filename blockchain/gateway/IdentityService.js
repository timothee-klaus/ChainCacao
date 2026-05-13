const FabricCAServices = require('fabric-ca-client');
const { User } = require('fabric-common');
const fs = require('fs').promises;
const path = require('path');
const networkConfig = require('./networkConfig');

class IdentityService {
    constructor(orgsRoot) {
        this.orgsRoot = orgsRoot;
    }

    async getWalletPath(orgName) {
        const walletPath = path.join(this.orgsRoot, 'wallets', orgName);
        await fs.mkdir(walletPath, { recursive: true });
        return walletPath;
    }

    async getFromWallet(orgName, userId) {
        const walletPath = await this.getWalletPath(orgName);
        const identityPath = path.join(walletPath, `${userId}.id`);
        try {
            const data = await fs.readFile(identityPath, 'utf8');
            const identity = JSON.parse(data);
            
            // Nettoyage des Buffers sérialisés
            if (identity.credentials) {
                if (identity.credentials.privateKey?.type === 'Buffer') {
                    identity.credentials.privateKey = Buffer.from(identity.credentials.privateKey.data).toString();
                }
                if (typeof identity.credentials.certificate === 'object' && identity.credentials.certificate.type === 'Buffer') {
                    identity.credentials.certificate = Buffer.from(identity.credentials.certificate.data).toString();
                }
            }
            return identity;
        } catch (error) {
            return null;
        }
    }

    async getIdentity(orgName, userId) {
        const identity = await this.getFromWallet(orgName, userId);
        if (identity) return identity;

        // Fallback automatique sur l'admin
        console.warn(`Identité ${userId} absente, utilisation de l'admin...`);
        let adminIdentity = await this.getFromWallet(orgName, 'admin');
        if (!adminIdentity) {
            await this.enrollAdminInWallet(orgName);
            adminIdentity = await this.getFromWallet(orgName, 'admin');
        }
        return adminIdentity;
    }

    async _getCACert(orgName) {
        const orgConfig = networkConfig.getOrgConfig(orgName);
        // Si on est en mode fallback (ex: on demande 'producteurs' mais on utilise 'test')
        // on doit chercher les certs dans le dossier de l'org réelle définie par l'hôte du peer.
        const realOrgName = (orgConfig.peerHost.split('.')[1]) || orgName;

        const possiblePaths = [
            path.join(this.orgsRoot, 'fabric-ca', realOrgName, 'ca-cert.pem'),
            path.join(this.orgsRoot, 'peerOrganizations', `${realOrgName}.chaincacao.com`, 'ca', `ca.${realOrgName}.chaincacao.com-cert.pem`),
            path.join(this.orgsRoot, 'peerOrganizations', `${realOrgName}.chaincacao.com`, 'tlsca', `tlsca.${realOrgName}.chaincacao.com-cert.pem`),
            // Fallback ultime sur le nom demandé si différent
            path.join(this.orgsRoot, 'fabric-ca', orgName, 'ca-cert.pem')
        ];

        for (const certPath of possiblePaths) {
            try {
                const cert = await fs.readFile(certPath, 'utf8');
                return cert;
            } catch (e) { continue; }
        }
        throw new Error(`Certificat CA introuvable pour ${orgName} (réel: ${realOrgName}) dans ${this.orgsRoot}`);
    }

    async enrollAdminInWallet(orgName, userId = 'admin', secret = 'adminpw') {
        const orgConfig = networkConfig.getOrgConfig(orgName);
        const tlsCert = await this._getCACert(orgName);
        const caService = new FabricCAServices(orgConfig.caUrl, { trustedRoots: [tlsCert], verify: false }, orgConfig.caName);
        
        const enrollment = await caService.enroll({ enrollmentID: userId, enrollmentSecret: secret });
        const identity = {
            credentials: { certificate: enrollment.certificate, privateKey: enrollment.key.toBytes() },
            mspId: orgConfig.mspId,
            type: 'X.509',
        };

        const walletPath = await this.getWalletPath(orgName);
        await fs.writeFile(path.join(walletPath, `${userId}.id`), JSON.stringify(identity, null, 2));
        console.log(`Admin ${userId} enrôlé avec succès pour ${orgName}`);
    }

    async registerAndEnrollUser(orgName, userId, role = 'client') {
        const orgConfig = networkConfig.getOrgConfig(orgName);
        const tlsCert = await this._getCACert(orgName);
        const caService = new FabricCAServices(orgConfig.caUrl, { trustedRoots: [tlsCert], verify: false }, orgConfig.caName);

        const adminIdentity = await this.getIdentity(orgName, 'admin');
        const adminUser = new User('admin');
        const cryptoSuite = FabricCAServices.newCryptoSuite();
        cryptoSuite.setCryptoKeyStore(FabricCAServices.newCryptoKeyStore());
        adminUser.setCryptoSuite(cryptoSuite);

        const privKey = await cryptoSuite.importKey(adminIdentity.credentials.privateKey, { ephemeral: true });
        await adminUser.setEnrollment(privKey, adminIdentity.credentials.certificate, adminIdentity.mspId);

        const secret = Math.random().toString(36).slice(-10);
        await caService.register({ 
            enrollmentID: userId, 
            enrollmentSecret: secret, 
            role: role, 
            affiliation: "", 
            maxEnrollments: -1 
        }, adminUser);
        
        const enrollment = await caService.enroll({ enrollmentID: userId, enrollmentSecret: secret });
        const identity = {
            credentials: { certificate: enrollment.certificate, privateKey: enrollment.key.toBytes() },
            mspId: orgConfig.mspId,
            type: 'X.509',
        };

        const walletPath = await this.getWalletPath(orgName);
        await fs.writeFile(path.join(walletPath, `${userId}.id`), JSON.stringify(identity, null, 2));
        return { success: true, userId, secret };
    }
}

module.exports = IdentityService;


