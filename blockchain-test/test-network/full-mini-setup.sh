#!/bin/bash
# ChainCacao - Complete Mini Network Setup (Sync & Deploy)
set -e

# 1. Bring down everything and clean
echo "### Cleaning environment..."
docker-compose -f docker-compose-test.yaml down --volumes --remove-orphans
rm -rf organizations/peerOrganizations organizations/ordererOrganizations system-genesis-block *.block *.tx

# 2. Start CA and enroll
echo "### Starting CA and Synchronizing Certificates..."
docker-compose -f docker-compose-test.yaml up -d ca.test.chaincacao.com
sleep 5
bash ./scripts/enroll-test-network.sh

# 3. Generate Channel Artifacts
echo "### Generating Genesis and Channel blocks..."
mkdir -p system-genesis-block
docker run --rm -v ${PWD}:/tmp/network -w /tmp/network -e FABRIC_CFG_PATH=/tmp/network hyperledger/fabric-tools:2.5 configtxgen -profile TestChannel -channelID testchannel -outputBlock ./testchannel.block

# 4. Start Network
echo "### Starting Peer and Orderer..."
docker-compose -f docker-compose-test.yaml up -d peer0.test.chaincacao.com orderer.test.chaincacao.com couchdb_test cli

# 5. Join Channel
echo "### Joining Channel..."
sleep 5

# Find Admin Key (Bash style)
ADMIN_KEY_PATH=$(ls organizations/peerOrganizations/test.chaincacao.com/users/Admin@test.chaincacao.com/msp/keystore/*_sk)

# Join Orderer (via Participation API)
docker run --rm --network host -v ${PWD}:/tmp/network hyperledger/fabric-tools:2.5 osnadmin channel join --channelID testchannel --config-block /tmp/network/testchannel.block -o localhost:17053 --ca-file /tmp/network/organizations/ordererOrganizations/test.chaincacao.com/orderers/orderer.test.chaincacao.com/tls/ca.crt --client-cert /tmp/network/organizations/peerOrganizations/test.chaincacao.com/users/Admin@test.chaincacao.com/msp/signcerts/cert.pem --client-key /tmp/network/${ADMIN_KEY_PATH}

# Join Peer
docker exec cli_test peer channel join -b testchannel.block

echo "### SUCCESS: Mini Network is ready for Chaincode! ###"
