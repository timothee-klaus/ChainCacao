const FabricCAServices = require('fabric-ca-client');
const { Wallets } = require('fabric-network');
const fs = require('fs');
const path = require('path');
const networkConfig = require('./networkConfig');

class IdentityService {
    constructor(orgsRoot) {
        this.orgsRoot = orgsRoot;
    }

    async getWallet(orgName) {
        const walletPath = path.join(this.orgsRoot, 'wallets', orgName);
        return await Wallets.newFileSystemWallet(walletPath);
    }

    async getIdentity(orgName, userId = 'admin') {
        const wallet = await this.getWallet(orgName);
        let identity = await wallet.get(userId);

        if (!identity && userId === 'admin') {
            await this.enrollAdminInWallet(orgName);
            identity = await wallet.get('admin');
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
        const wallet = await this.getWallet(orgName);

        const tlsCertPath = path.join(this.orgsRoot, 'fabric-ca', orgName, 'ca-cert.pem');
        const tlsCert = fs.readFileSync(tlsCertPath).toString();
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

        await wallet.put('admin', x509Identity);
        console.log(`Admin for ${orgName} enrolled successfully.`);
    }

    async registerAndEnrollUser(orgName, userId, role = 'client') {
        const orgConfig = networkConfig.organizations[orgName];
        if (!orgConfig) throw new Error(`Configuration non trouvée pour l'organisation: ${orgName}`);

        const caUrl = orgConfig.caUrl;
        const wallet = await this.getWallet(orgName);

        if (await wallet.get(userId)) {
            throw new Error(`L'utilisateur ${userId} existe déjà dans le wallet.`);
        }

        const tlsCertPath = path.join(this.orgsRoot, 'fabric-ca', orgName, 'ca-cert.pem');
        const tlsCert = fs.readFileSync(tlsCertPath).toString();
        const caService = new FabricCAServices(caUrl, { trustedRoots: [tlsCert], verify: false }, orgConfig.caName);

        const adminIdentity = await this.getIdentity(orgName, 'admin');
        const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
        const adminUser = await provider.getUserContext(adminIdentity, 'admin');

        // Use a generated secret instead of a hardcoded one
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

        await wallet.put(userId, x509Identity);
        return { success: true, userId, secret: enrollmentSecret };
    }
}

module.exports = IdentityService;

