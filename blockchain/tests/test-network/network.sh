#!/bin/bash

# Exit on first error
set -e

# Import environment
source .env

export PATH=${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}

function clearContainers() {
  CONTAINER_IDS=$(docker ps -a | grep "chaincacao_test" | awk '{print $1}')
  if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
    echo "---- No containers available for deletion ----"
  else
    docker rm -f $CONTAINER_IDS
  fi
}

function removeUnusedImages() {
  DOCKER_IMAGE_IDS=$(docker images | grep "dev-peer0.org1.test.chaincacao.com" | awk '{print $3}')
  if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
    echo "---- No images available for deletion ----"
  else
    docker rmi -f $DOCKER_IMAGE_IDS
  fi
}

function networkUp() {
  # 1. Start Fabric CA first
  echo "### Starting Fabric CA ###"
  docker-compose -f docker-compose-test.yaml up -d ca.test.chaincacao.com
  sleep 5 # Wait for CA to be ready

  # 2. Generate crypto material using Fabric CA
  if [ ! -d "organizations/peerOrganizations" ]; then
    echo "### Generating crypto material via CA ###"
    bash ./scripts/enroll-test-network.sh
  fi

  # 3. Generate genesis block (if not present)
  if [ ! -d "system-genesis-block" ]; then
    mkdir system-genesis-block
    echo "### Generating orderer genesis block ###"
    MSYS_NO_PATHCONV=1 docker run --rm -v ${PWD}:/opt/gopath/src/github.com/hyperledger/fabric/peer -w /opt/gopath/src/github.com/hyperledger/fabric/peer -e FABRIC_CFG_PATH=/opt/gopath/src/github.com/hyperledger/fabric/peer hyperledger/fabric-tools:${IMAGE_TAG:-2.5} configtxgen -profile TestOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block
  fi

  # 4. Start the rest of the network
  docker-compose -f docker-compose-test.yaml up -d

  echo "### Network is UP & Synced with CA ###"
}

function networkDown() {
  docker-compose -f docker-compose-test.yaml down --volumes --remove-orphans
  
  # Don't remove the crypto material unless requested
  # rm -rf organizations/peerOrganizations organizations/ordererOrganizations
  # rm -rf system-genesis-block channel-artifacts
  
  clearContainers
  removeUnusedImages
  
  echo "### Network is DOWN ###"
}

case "$1" in
  up)
    networkUp
    ;;
  down)
    networkDown
    ;;
  restart)
    networkDown
    networkUp
    ;;
  *)
    echo "Usage: $0 {up|down|restart}"
    exit 1
esac
