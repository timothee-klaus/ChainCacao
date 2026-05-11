const express = require('express');
const grpc = require('@grpc/grpc-js');
const { connect, signers } = require('@hyperledger/fabric-gateway');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const envPath = process.env.DOTENV_CONFIG_PATH ? path.resolve(__dirname, process.env.DOTENV_CONFIG_PATH) : path.resolve(__dirname, '.env');
require('dotenv').config({ path: envPath });

const IdentityService = require('./IdentityService');
const networkConfig = require('./networkConfig');

const app = express();
app.use(express.json());

const ORGS_ROOT = path.resolve(__dirname, process.env.ORGS_ROOT || '../organizations');
const CHANNEL_NAME = process.env.CHANNEL_NAME || 'chaincacaochannel';
const CHAINCODE_NAME = process.env.CHAINCODE_NAME || 'chaincacao';
const identityService = new IdentityService(ORGS_ROOT);

async function getGatewayConnection(requestedOrg, userId = 'admin') {
    const orgConfig = networkConfig.getOrgConfig(requestedOrg);
    // On utilise le nom de l'organisation réelle (ex: 'test') pour les chemins de fichiers
    const realOrgName = (orgConfig.peerHost.split('.')[1]) || requestedOrg; 
    
    const identity = await identityService.getIdentity(requestedOrg, userId);
    const privateKey = crypto.createPrivateKey(identity.credentials.privateKey);

    const tlsCertPath = path.join(ORGS_ROOT, 'peerOrganizations', `${realOrgName}.chaincacao.com`, 'peers', orgConfig.peerHost, 'tls', 'ca.crt');
    const tlsRootCert = fs.readFileSync(tlsCertPath);

    const client = new grpc.Client(`localhost:${orgConfig.peerPort}`, grpc.credentials.createSsl(tlsRootCert), {
        'grpc.ssl_target_name_override': orgConfig.peerHost,
    });

    return {
        gateway: connect({
            client,
            identity: { mspId: identity.mspId, credentials: Buffer.from(identity.credentials.certificate) },
            signer: signers.newPrivateKeySigner(privateKey),
            discovery: { enabled: true, asLocalhost: true },
        }),
        client
    };
}

app.post('/invoke', async (req, res) => {
    const { function: fn, args } = req.body;
    const orgName = req.header('X-Org-Name') || 'test';
    const userId = req.header('X-User-ID') || 'admin';

    let connection;
    try {
        connection = await getGatewayConnection(orgName, userId);
        const network = connection.gateway.getNetwork(CHANNEL_NAME);
        const contract = network.getContract(CHAINCODE_NAME);

        console.log(`Transaction: ${fn} (${userId}@${orgName})`);
        const resultBytes = await contract.submitTransaction(fn, ...args);
        const result = Buffer.from(resultBytes).toString();

        res.json({ success: true, result: result ? JSON.parse(result) : null });
    } catch (error) {
        console.error('Invoke Error:', error.message);
        res.status(500).json({ success: false, error: error.message });
    } finally {
        if (connection) connection.client.close();
    }
});

app.post('/query', async (req, res) => {
    const { function: fn, args } = req.body;
    const orgName = req.header('X-Org-Name') || 'test';
    const userId = req.header('X-User-ID') || 'admin';

    let connection;
    try {
        connection = await getGatewayConnection(orgName, userId);
        const network = connection.gateway.getNetwork(CHANNEL_NAME);
        const contract = network.getContract(CHAINCODE_NAME);

        const resultBytes = await contract.evaluateTransaction(fn, ...args);
        const result = Buffer.from(resultBytes).toString();

        res.json({ success: true, result: result ? JSON.parse(result) : null });
    } catch (error) {
        console.error('Query Error:', error.message);
        res.status(500).json({ success: false, error: error.message });
    } finally {
        if (connection) connection.client.close();
    }
});

app.post('/register', async (req, res) => {
    const { userId, orgName, role } = req.body;
    try {
        const result = await identityService.registerAndEnrollUser(orgName, userId, role);
        res.json(result);
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`🚀 Gateway TEST active sur port ${PORT}`));

