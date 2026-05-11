const networkConfig = {
    organizations: {
        'producteurs': {
            mspId: 'OrgProducteursMSP',
            peerPort: 7051,
            caUrl: 'https://localhost:7054',
            caName: 'ca-producteurs',
            peerHost: 'peer0.producteurs.chaincacao.com'
        },
        'exportateurs': {
            mspId: 'OrgExportateursMSP',
            peerPort: 8051,
            caUrl: 'https://localhost:8054',
            caName: 'ca-exportateurs',
            peerHost: 'peer0.exportateurs.chaincacao.com'
        },
        'certif': {
            mspId: 'OrgCertifMSP',
            peerPort: 9051,
            caUrl: 'https://localhost:9054',
            caName: 'ca-certif',
            peerHost: 'peer0.certif.chaincacao.com'
        },
        'ministere': {
            mspId: 'OrgMinistereMSP',
            peerPort: 10051,
            caUrl: 'https://localhost:10054',
            caName: 'ca-ministere',
            peerHost: 'peer0.ministere.chaincacao.com'
        },
        'transformateurs': {
            mspId: 'OrgTransformateursMSP',
            peerPort: 11051,
            caUrl: 'https://localhost:11054',
            caName: 'ca-transformateurs',
            peerHost: 'peer0.transformateurs.chaincacao.com'
        },
        'test': {
            mspId: 'OrgTestMSP',
            peerPort: 17051,
            caUrl: 'https://localhost:17054',
            caName: 'ca-test',
            peerHost: 'peer0.test.chaincacao.com'
        }
    },
    // Fonction utilitaire pour obtenir la config
    // SUR LA VM: On force l'utilisation de 'test' pour mapper le réseau ultra-light
    getOrgConfig(orgName) {
        // Si la config 'test' est présente, on l'utilise par défaut pour TOUT sur la VM
        // afin d'éviter les erreurs de port (7051 vs 17051)
        if (this.organizations['test']) {
            return this.organizations['test'];
        }
        return this.organizations[orgName] || this.organizations['test'];
    }
};

module.exports = networkConfig;


