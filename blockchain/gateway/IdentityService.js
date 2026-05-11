const FabricCAServices = require('fabric-ca-client');
const { User } = require('fabric-common');
const fs = require('fs').promises;
const path = require('path');
const crypto = require('crypto');
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
            
            // Re-convertir les Buffers sérialisés par JSON.stringify en chaînes PEM
            if (identity.credentials && identity.credentials.privateKey && identity.credentials.privateKey.type === 'Buffer') {
                identity.credentials.privateKey = Buffer.from(identity.credentials.privateKey.data).toString();
            }
            if (identity.credentials && identity.credentials.certificate && typeof identity.credentials.certificate === 'object' && identity.credentials.certificate.type === 'Buffer') {
                identity.credentials.certificate = Buffer.from(identity.credentials.certificate.data).toString();
            }
            
            return identity;
        } catch (error) {
            return null; // Identity not found
        }
    }

    async putInWallet(orgName, userId, identity) {
        const walletPath = await this.getWalletPath(orgName);
        const identityPath = path.join(walletPath, `${userId}.id`);
        await fs.writeFile(identityPath, JSON.stringify(identity, null, 2));
    }

    async getIdentity(orgName, userId = 'admin') {
        let identity = await this.getFromWallet(orgName, userId);

        if (!identity && userId === 'admin') {
            await this.enrollAdminInWallet(orgName);
            identity = await this.getFromWallet(orgName, 'admin');
        }

        if (!identity) {
            throw new Error(`Identité ${userId} non trouvée dans le wallet de ${orgName}`);
        }

        return identity;
    }

    async enrollAdminInWallet(orgName, userId = 'admin', secret = 'adminpw') {
        const orgConfig = networkConfig.organizations[orgName];
        if (!orgConfig) throw new Error(`Configuration non trouvée pour l'organisation: ${orgName}`);

        const caUrl = orgConfig.caUrl;
        const tlsCertPath = path.join(this.orgsRoot, 'peerOrganizations', `${orgName}.chaincacao.com`, 'tlsca', `tlsca.${orgName}.chaincacao.com-cert.pem`);
        const tlsCert = await fs.readFile(tlsCertPath, 'utf8');

        const caService = new FabricCAServices(caUrl, { trustedRoots: [tlsCert], verify: false }, orgConfig.caName);
        
        console.log(`Enrolling ${userId} for org ${orgName} at ${caUrl}...`);
        const enrollment = await caService.enroll({
            enrollmentID: userId,
            enrollmentSecret: secret
        });

        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: orgConfig.mspId,
            type: 'X.509',
        };

        await this.putInWallet(orgName, userId, x509Identity);
        console.log(`Successfully enrolled ${userId} and saved to wallet`);
    }

    async registerAndEnrollUser(orgName, userId, role = 'client') {
        const orgConfig = networkConfig.organizations[orgName];
        if (!orgConfig) throw new Error(`Configuration non trouvée pour l'organisation: ${orgName}`);

        const caUrl = orgConfig.caUrl;
        
        if (await this.getFromWallet(orgName, userId)) {
            throw new Error(`L'utilisateur ${userId} existe déjà dans le wallet.`);
        }

        const tlsCertPath = path.join(this.orgsRoot, 'fabric-ca', orgName, 'ca-cert.pem');
        const tlsCert = await fs.readFile(tlsCertPath, 'utf8');
        const caService = new FabricCAServices(caUrl, { trustedRoots: [tlsCert], verify: false }, orgConfig.caName);

        // Enrol admin dynamically if not present
        let adminIdentity = await this.getFromWallet(orgName, 'admin');
        if (!adminIdentity) {
            await this.enrollAdminInWallet(orgName);
            adminIdentity = await this.getFromWallet(orgName, 'admin');
        }
        
        // Create a real User object for the registrar
        const adminUser = new User('admin');
        const cryptoSuite = FabricCAServices.newCryptoSuite();
        cryptoSuite.setCryptoKeyStore(FabricCAServices.newCryptoKeyStore());
        adminUser.setCryptoSuite(cryptoSuite);

        // Importer la clé privée proprement dans le CryptoSuite (conversion PEM -> Key object)
        const privKey = await cryptoSuite.importKey(adminIdentity.credentials.privateKey, { ephemeral: true });

        await adminUser.setEnrollment(
            privKey,
            adminIdentity.credentials.certificate,
            adminIdentity.mspId
        );

        const enrollmentSecret = Math.random().toString(36).slice(-10);

        await caService.register({
            enrollmentID: userId,
            enrollmentSecret: enrollmentSecret,
            role: role,
            maxEnrollments: -1
        }, adminUser);

        const enrollment = await caService.enroll({
            enrollmentID: userId,
            enrollmentSecret: enrollmentSecret
        });

        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: orgConfig.mspId,
            type: 'X.509',
        };

        await this.putInWallet(orgName, userId, x509Identity);
        return { success: true, userId, secret: enrollmentSecret };
    }
}

module.exports = IdentityService;

