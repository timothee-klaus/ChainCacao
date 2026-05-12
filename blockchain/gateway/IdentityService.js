const FabricCAServices = require('fabric-ca-client');
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
            return JSON.parse(data);
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

    async enrollAdminInWallet(orgName) {
        const orgConfig = networkConfig.organizations[orgName];
        if (!orgConfig) throw new Error(`Configuration non trouvée pour l'organisation: ${orgName}`);

        const caUrl = orgConfig.caUrl;
        
        const tlsCertPath = path.join(this.orgsRoot, 'fabric-ca', orgName, 'ca-cert.pem');
        const tlsCert = await fs.readFile(tlsCertPath, 'utf8');
        const caService = new FabricCAServices(caUrl, { trustedRoots: [tlsCert], verify: false }, orgConfig.caName);

        const enrollment = await caService.enroll({
            enrollmentID: 'admin',
            enrollmentSecret: process.env.CA_ADMIN_PASS || 'adminpw'
        });

        const x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: orgConfig.mspId,
            type: 'X.509',
        };

        await this.putInWallet(orgName, 'admin', x509Identity);
        console.log(`Admin for ${orgName} enrolled successfully.`);
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
        
        // Mock a user object for fabric-ca-client registrar using basic methods
        const adminUser = {
            getName: () => 'admin',
            getSigningIdentity: () => ({
                _certificate: adminIdentity.credentials.certificate,
                sign: (msg) => {
                    const crypto = require('crypto');
                    const sign = crypto.createSign('SHA256');
                    sign.update(msg);
                    const privateKey = crypto.createPrivateKey(adminIdentity.credentials.privateKey);
                    return sign.sign(privateKey, 'hex');
                }
            })
        };

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

