#!/bin/bash
# ChainCacao - Complete Mini Network Setup (Sync & Deploy)
set -e

# 1. Bring down everything and clean
echo "### 1. Cleaning environment..."
docker-compose -f docker-compose-test.yaml down --volumes --remove-orphans
rm -rf organizations/peerOrganizations organizations/ordererOrganizations organizations/fabric-ca system-genesis-block *.block *.tx
rm -rf organizations/wallets/*

# 2. Start CA and enroll
echo "### 2. Starting CA and Synchronizing Certificates..."
docker-compose -f docker-compose-test.yaml up -d ca.test.chaincacao.com
sleep 5
bash ./scripts/enroll-test-network.sh

# 3. Generate Channel Artifacts
echo "### 3. Generating Genesis and Channel blocks..."
mkdir -p system-genesis-block
# Note: Using locally installed configtxgen if possible, else docker
if command -v configtxgen &> /dev/null; then
    configtxgen -profile TestChannel -channelID testchannel -outputBlock ./testchannel.block
else
    docker run --rm -v ${PWD}:/tmp/network -w /tmp/network -e FABRIC_CFG_PATH=/tmp/network hyperledger/fabric-tools:2.5 configtxgen -profile TestChannel -channelID testchannel -outputBlock ./testchannel.block
fi

# 4. Start Network
echo "### 4. Pulling Chaincode Builder Image and Starting Network..."
docker pull hyperledger/fabric-nodeenv:2.5
echo "Starting Peer and Orderer..."
docker-compose -f docker-compose-test.yaml up -d peer0.test.chaincacao.com orderer.test.chaincacao.com couchdb_test cli
sleep 5

# 5. Join Channel
echo "### 5. Joining Channel..."
# Join Orderer (via Participation API, bypassing internal DNS using host network)
docker run --rm --network host -v ${PWD}:/tmp/network hyperledger/fabric-tools:2.5 osnadmin channel join --channelID testchannel --config-block /tmp/network/testchannel.block -o localhost:17053 --ca-file /tmp/network/organizations/ordererOrganizations/test.chaincacao.com/orderers/orderer.test.chaincacao.com/tls/ca.crt --client-cert /tmp/network/organizations/ordererOrganizations/test.chaincacao.com/orderers/orderer.test.chaincacao.com/tls/server.crt --client-key /tmp/network/organizations/ordererOrganizations/test.chaincacao.com/orderers/orderer.test.chaincacao.com/tls/server.key

# Join Peer
docker exec cli_test peer channel join -b testchannel.block

# Wait for Raft leader election to complete
echo "Waiting for Orderer Raft election..."
sleep 3

# 6. Deploy Chaincode
echo "### 6. Deploying Chaincode with OrgTestMSP policy..."
docker exec cli_test ./scripts/deployCC.sh

# 7. Setup Gateway Identity
echo "### 7. Gateway will automatically enroll its root admin upon first request."

# 7.5. Setup Permissions for Gateway
echo "### 7.5. Granting write permissions to organizations folder for Gateway wallets..."
chmod -R 777 organizations

# 8. Restart Gateway
echo "### 8. Restarting Gateway with PM2..."
# On suppose que la gateway est dans blockchain/gateway
if [ -d "../../gateway" ]; then
    (cd "../../gateway" && pm2 restart all --update-env)
fi

# 9. Start Monitoring
echo "### 9. Starting Prometheus & Grafana Monitoring..."
if [ -d "./monitoring" ]; then
    docker-compose -f ./monitoring/docker-compose-monitoring.yaml up -d
    echo "📊 Monitoring available at: http://localhost:3002 (Grafana) and http://localhost:9091 (Prometheus)"
fi

echo "### SUCCESS: MINI NETWORK IS FULLY OPERATIONAL! 🚀 ###"
