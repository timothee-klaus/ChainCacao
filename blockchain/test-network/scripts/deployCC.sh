#!/bin/bash

source scripts/envVar.sh
export PATH=${PWD}/../bin:$PATH

CC_NAME=${1:-"chaincacao"}
CC_SRC_PATH=${2:-"/opt/gopath/src/github.com/hyperledger/fabric-samples/chaincode-test"}
CC_VERSION=${3:-"1.0"}
CC_SEQUENCE=${4:-"1"}
CC_RUNTIME_LANGUAGE="node"
CHANNEL_NAME="testchannel"
COLLECTIONS_CONFIG="--collections-config ./collections_config_test.json"

packageChaincode() {
  echo "### Packaging chaincode ###"
  set -x
  peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION} >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
}

installChaincode() {
  ORG=$1
  setGlobals $ORG
  echo "### Installing chaincode on peer0.org${ORG} ###"
  set -x
  peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
}

queryInstalled() {
  ORG=$1
  setGlobals $ORG
  echo "### Querying installed chaincode on peer0.org${ORG} ###"
  set -x
  peer lifecycle chaincode queryinstalled >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
  PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
}

approveForMyOrg() {
  ORG=$1
  setGlobals $ORG
  echo "### Approving chaincode for org${ORG} ###"
  set -x
  peer lifecycle chaincode approveformyorg -o orderer.test.chaincacao.com:17050 --ordererTLSHostnameOverride orderer.test.chaincacao.com --tls --cafile "$ORDERER_CA" --channelID ${CHANNEL_NAME} --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} --signature-policy "OR('OrgTestMSP.member')" ${COLLECTIONS_CONFIG} >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
}

commitChaincodeDefinition() {
  parsePeerConnectionParameters 1
  echo "### Committing chaincode definition ###"
  set -x
  peer lifecycle chaincode commit -o orderer.test.chaincacao.com:17050 --ordererTLSHostnameOverride orderer.test.chaincacao.com --tls --cafile "$ORDERER_CA" --channelID ${CHANNEL_NAME} --name ${CC_NAME} $PEER_CONN_PARMS --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --signature-policy "OR('OrgTestMSP.member')" ${COLLECTIONS_CONFIG} >&log.txt
  res=$?
  { set +x; } 2>/dev/null
  cat log.txt
}

## Package the chaincode
packageChaincode

## Install chaincode on peer0.org1
installChaincode 1

## query whether the chaincode is installed
queryInstalled 1

## approve the definition for org1
approveForMyOrg 1

## commit the definition
commitChaincodeDefinition

echo "Chaincode deployment complete"
