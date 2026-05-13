#!/bin/bash

[ -f scripts/envVar.sh ] && source scripts/envVar.sh || source ./envVar.sh
export PATH=${PWD}/../bin:$PATH

CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
: ${CHANNEL_NAME:="testchannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}

if [ ! -d "channel-artifacts" ]; then
	mkdir channel-artifacts
fi

createChannelGenesisBlock() {
	echo "### Generating channel configuration transaction 'genesis.block' ###"
	set -x
	MSYS_NO_PATHCONV=1 docker exec -e FABRIC_CFG_PATH=/opt/gopath/src/github.com/hyperledger/fabric/peer cli_test configtxgen -profile TestChannel -outputBlock ./channel-artifacts/${CHANNEL_NAME}.block -channelID $CHANNEL_NAME
	res=$?
	{ set +x; } 2>/dev/null
  if [ $res -ne 0 ]; then
    echo "Failed to generate channel configuration transaction..."
    exit 1
  fi
}

createChannel() {
	setGlobals 1
	# Poll for the orderer to be available
	local rc=1
	local COUNTER=1
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
		sleep $DELAY
		set -x
		MSYS_NO_PATHCONV=1 docker exec -e FABRIC_CFG_PATH=/opt/gopath/src/github.com/hyperledger/fabric/peer cli_test osnadmin channel join --channelID ${CHANNEL_NAME} --config-block ./channel-artifacts/${CHANNEL_NAME}.block -o orderer.test.chaincacao.com:17053 --ca-file /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/test.chaincacao.com/orderers/orderer.test.chaincacao.com/tls/ca.crt --client-cert /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/test.chaincacao.com/orderers/orderer.test.chaincacao.com/tls/server.crt --client-key /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/test.chaincacao.com/orderers/orderer.test.chaincacao.com/tls/server.key >&log.txt
		res=$?
		{ set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	verifyResult $res "Channel creation failed"
}

# joinChannel ORG
joinChannel() {
  ORG=$1
  setGlobals $ORG
	local rc=1
	local COUNTER=1
	## Currently retry JOIN because [chaincode-docker-run] may not be ready
	while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ] ; do
    sleep $DELAY
    set -x
    MSYS_NO_PATHCONV=1 docker exec -e CORE_PEER_ADDRESS=peer0.test.chaincacao.com:17051 cli_test peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block >&log.txt
    res=$?
    { set +x; } 2>/dev/null
		let rc=$res
		COUNTER=$(expr $COUNTER + 1)
	done
	cat log.txt
	echo "### After $MAX_RETRY attempts, peer0.org${ORG} has joined channel '$CHANNEL_NAME' ###"
}

setAnchorPeer() {
  ORG=$1
  MSYS_NO_PATHCONV=1 docker exec cli_test ./scripts/setAnchorPeer.sh $ORG $CHANNEL_NAME
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}

FABRIC_CFG_PATH=$PWD

## Create genesis block
createChannelGenesisBlock

## Create channel
echo "Creating channel ${CHANNEL_NAME}"
createChannel

## Join all the peers to the channel
echo "Joining org1 peer to the channel..."
joinChannel 1

echo "Channel successfully joined"
