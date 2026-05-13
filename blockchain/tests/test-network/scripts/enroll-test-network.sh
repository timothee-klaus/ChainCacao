#!/bin/bash
# ChainCacao - Mini Test Network Enrollment Script
set -e

# Get variables from .env if present
if [ -f .env ]; then
    source .env
fi

CA_PORT=${CA_PORT:-17054}
CA_IMAGE_TAG=${CA_IMAGE_TAG:-1.5}
ORG_NAME="test"
DOMAIN="test.chaincacao.com"
ORG_DIR="organizations/peerOrganizations/${DOMAIN}"

echo "### 1. Waiting for CA to be ready..."
# We assume the CA container is already started by network.sh

echo "### 2. Enrolling CA Admin to get access..."
mkdir -p "${ORG_DIR}/msp"
docker run --rm --network host -v ${PWD}:/tmp/network -w /tmp/network hyperledger/fabric-ca:${CA_IMAGE_TAG} \
  fabric-ca-client enroll -u https://admin:adminpw@localhost:${CA_PORT} --caname ca-test \
  --tls.certfiles /tmp/network/organizations/fabric-ca/test/tls-cert.pem \
  --mspdir /tmp/network/${ORG_DIR}/msp

# Fix folder structure
mkdir -p "${ORG_DIR}/msp/cacerts"
cp organizations/fabric-ca/test/ca-cert.pem "${ORG_DIR}/msp/cacerts/"
mkdir -p "${ORG_DIR}/msp/tlscacerts"
cp organizations/fabric-ca/test/ca-cert.pem "${ORG_DIR}/msp/tlscacerts/"

echo "### 3. Registering and Enrolling Peer0..."
docker run --rm --network host -v ${PWD}:/tmp/network -w /tmp/network hyperledger/fabric-ca:${CA_IMAGE_TAG} \
  fabric-ca-client register -u https://admin:adminpw@localhost:${CA_PORT} --caname ca-test --id.name peer0 --id.secret peer0pw --id.type peer \
  --tls.certfiles /tmp/network/organizations/fabric-ca/test/tls-cert.pem \
  --mspdir /tmp/network/${ORG_DIR}/msp

mkdir -p "${ORG_DIR}/peers/peer0.${DOMAIN}/msp"
docker run --rm --network host -v ${PWD}:/tmp/network -w /tmp/network hyperledger/fabric-ca:${CA_IMAGE_TAG} \
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:${CA_PORT} --caname ca-test \
  -M /tmp/network/${ORG_DIR}/peers/peer0.${DOMAIN}/msp \
  --csr.hosts peer0.${DOMAIN},localhost,127.0.0.1 \
  --tls.certfiles /tmp/network/organizations/fabric-ca/test/tls-cert.pem

# Peer TLS
mkdir -p "${ORG_DIR}/peers/peer0.${DOMAIN}/tls"
cp "${ORG_DIR}/peers/peer0.${DOMAIN}/msp/signcerts/"* "${ORG_DIR}/peers/peer0.${DOMAIN}/tls/server.crt"
cp "${ORG_DIR}/peers/peer0.${DOMAIN}/msp/keystore/"* "${ORG_DIR}/peers/peer0.${DOMAIN}/tls/server.key"
cp organizations/fabric-ca/test/ca-cert.pem "${ORG_DIR}/peers/peer0.${DOMAIN}/tls/ca.crt"

echo "### 4. Registering and Enrolling Admin User..."
docker run --rm --network host -v ${PWD}:/tmp/network -w /tmp/network hyperledger/fabric-ca:${CA_IMAGE_TAG} \
  fabric-ca-client register -u https://admin:adminpw@localhost:${CA_PORT} --caname ca-test --id.name admin-org --id.secret admin-org-pw --id.type admin \
  --tls.certfiles /tmp/network/organizations/fabric-ca/test/tls-cert.pem \
  --mspdir /tmp/network/${ORG_DIR}/msp

mkdir -p "${ORG_DIR}/users/Admin@${DOMAIN}/msp"
docker run --rm --network host -v ${PWD}:/tmp/network -w /tmp/network hyperledger/fabric-ca:${CA_IMAGE_TAG} \
  fabric-ca-client enroll -u https://admin-org:admin-org-pw@localhost:${CA_PORT} --caname ca-test \
  -M /tmp/network/${ORG_DIR}/users/Admin@${DOMAIN}/msp \
  --tls.certfiles /tmp/network/organizations/fabric-ca/test/tls-cert.pem

# Copy Admin cert to peer/msp/admincerts (Mandatory for peer node)
mkdir -p "${ORG_DIR}/peers/peer0.${DOMAIN}/msp/admincerts"
cp "${ORG_DIR}/users/Admin@${DOMAIN}/msp/signcerts/"* "${ORG_DIR}/peers/peer0.${DOMAIN}/msp/admincerts/"

# Copy Admin cert to Global Org MSP
mkdir -p "${ORG_DIR}/msp/admincerts"
cp "${ORG_DIR}/users/Admin@${DOMAIN}/msp/signcerts/"* "${ORG_DIR}/msp/admincerts/"

# Copy Admin cert to Admin User's own MSP (Mandatory for CLI commands)
mkdir -p "${ORG_DIR}/users/Admin@${DOMAIN}/msp/admincerts"
cp "${ORG_DIR}/users/Admin@${DOMAIN}/msp/signcerts/"* "${ORG_DIR}/users/Admin@${DOMAIN}/msp/admincerts/"

echo "### 5. Registering and Enrolling Orderer..."
docker run --rm --network host -v ${PWD}:/tmp/network -w /tmp/network hyperledger/fabric-ca:${CA_IMAGE_TAG} \
  fabric-ca-client register -u https://admin:adminpw@localhost:${CA_PORT} --caname ca-test --id.name orderer --id.secret ordererpw --id.type orderer \
  --tls.certfiles /tmp/network/organizations/fabric-ca/test/tls-cert.pem \
  --mspdir /tmp/network/${ORG_DIR}/msp

ORDERER_DIR="organizations/ordererOrganizations/${DOMAIN}/orderers/orderer.${DOMAIN}"
mkdir -p "${ORDERER_DIR}/msp"
docker run --rm --network host -v ${PWD}:/tmp/network -w /tmp/network hyperledger/fabric-ca:${CA_IMAGE_TAG} \
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:${CA_PORT} --caname ca-test \
  -M /tmp/network/${ORDERER_DIR}/msp \
  --csr.hosts orderer.${DOMAIN},localhost,127.0.0.1 \
  --tls.certfiles /tmp/network/organizations/fabric-ca/test/tls-cert.pem

# Orderer TLS
mkdir -p "${ORDERER_DIR}/tls"
cp "${ORDERER_DIR}/msp/signcerts/"* "${ORDERER_DIR}/tls/server.crt"
cp "${ORDERER_DIR}/msp/keystore/"* "${ORDERER_DIR}/tls/server.key"
cp organizations/fabric-ca/test/ca-cert.pem "${ORDERER_DIR}/tls/ca.crt"

# Orderer Global MSP
mkdir -p "organizations/ordererOrganizations/${DOMAIN}/msp/cacerts"
cp organizations/fabric-ca/test/ca-cert.pem "organizations/ordererOrganizations/${DOMAIN}/msp/cacerts/"
mkdir -p "organizations/ordererOrganizations/${DOMAIN}/msp/tlscacerts"
cp organizations/fabric-ca/test/ca-cert.pem "organizations/ordererOrganizations/${DOMAIN}/msp/tlscacerts/"

# Orderer Admin (Global)
mkdir -p "organizations/ordererOrganizations/${DOMAIN}/msp/admincerts"
cp "${ORG_DIR}/users/Admin@${DOMAIN}/msp/signcerts/"* "organizations/ordererOrganizations/${DOMAIN}/msp/admincerts/"

# Orderer Admin (Local Node)
mkdir -p "${ORDERER_DIR}/msp/admincerts"
cp "${ORG_DIR}/users/Admin@${DOMAIN}/msp/signcerts/"* "${ORDERER_DIR}/msp/admincerts/"

echo "### Enrollment completed successfully! ###"
