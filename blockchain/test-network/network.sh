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
  # 1. Generate crypto material using Fabric CA (simplified for this script: using cryptogen for speed)
  # In a real scenario, use CA scripts. Here we use cryptogen for the "ultra-light" requirement.
  if [ ! -d "organizations/peerOrganizations" ]; then
    echo "### Generating crypto material ###"
    cryptogen generate --config=./crypto-config.yaml --output="organizations"
  fi
  # Fix Windows backslashes in config.yaml for Linux containers
  find organizations -name "config.yaml" -exec sed -i 's/\\/\//g' {} +

  # 2. Generate genesis block
  if [ ! -d "system-genesis-block" ]; then
    mkdir system-genesis-block
    echo "### Generating orderer genesis block ###"
    MSYS_NO_PATHCONV=1 docker run --rm -v ${PWD}:/opt/gopath/src/github.com/hyperledger/fabric/peer -w /opt/gopath/src/github.com/hyperledger/fabric/peer -e FABRIC_CFG_PATH=/opt/gopath/src/github.com/hyperledger/fabric/peer hyperledger/fabric-tools:${IMAGE_TAG:-2.5} configtxgen -profile TestOrdererGenesis -channelID system-channel -outputBlock ./system-genesis-block/genesis.block
  fi

  # 3. Start containers
  docker-compose -f docker-compose-test.yaml up -d

  echo "### Network is UP ###"
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
