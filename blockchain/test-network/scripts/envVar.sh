#!/bin/bash

# This script sets environment variables for the peer and cli containers

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/test.chaincacao.com/orderers/orderer.test.chaincacao.com/tls/ca.crt
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/test.chaincacao.com/peers/peer0.test.chaincacao.com/tls/ca.crt

# Set environment variables for the target org
setGlobals() {
  local USING_ORG=$1
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="OrgTestMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/test.chaincacao.com/users/Admin@test.chaincacao.com/msp
    export CORE_PEER_ADDRESS=peer0.test.chaincacao.com:17051
    export CORE_PEER_TLS_CERT_FILE=${PWD}/organizations/peerOrganizations/test.chaincacao.com/peers/peer0.test.chaincacao.com/tls/server.crt
    export CORE_PEER_TLS_KEY_FILE=${PWD}/organizations/peerOrganizations/test.chaincacao.com/peers/peer0.test.chaincacao.com/tls/server.key
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=""
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    REMOTE_PEER="peer0.test.chaincacao.com:17051"
    PEERS="$PEERS $REMOTE_PEER"
    ## Set peer addresses
    PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $REMOTE_PEER"
    ## Set path to TLS certificate
    TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER0_ORG$1_CA")
    PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift to next arg
    shift
  done
  # remove leading space
  PEERS="$(echo -e "${PEERS}" | sed -e 's/^[[:space:]]*//')"
}
