#!/bin/bash

echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Build your first network (BYFN) end-to-end test"
echo
CHANNEL_NAME="$1"
DELAY="$2"
LANGUAGE="$3"
TIMEOUT="$4"
VERBOSE="$5"
: ${CHANNEL_NAME:="mychannel"}
: ${DELAY:="3"}
: ${LANGUAGE:="golang"}
: ${TIMEOUT:="10"}
: ${VERBOSE:="false"}
LANGUAGE=`echo "$LANGUAGE" | tr [:upper:] [:lower:]`
COUNTER=1
MAX_RETRY=5

#CC_SRC_PATH="github.com/chaincode/chaincode_example02/go/"
#if [ "$LANGUAGE" = "node" ]; then
## SINCE WE ARE USING ONLY NODE FOR WRITING CHAINCODE
CC_SRC_PATH="/opt/gopath/src/github.com/letterofcredit/chaincode/node/"
#fi

export COMPOSE_PROJECT_NAME="letterofcredit"

echo "Channel name : "$CHANNEL_NAME

# import utils
. scripts/utils.sh

createChannel() {
	setGlobals 0 1

	if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
                set -x
		peer channel create -o orderer.letterofcredit.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx >&log.txt
		res=$?
                set +x
	else
				set -x
		peer channel create -o orderer.letterofcredit.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
		res=$?
				set +x
	fi
	cat log.txt
	verifyResult $res "Channel creation failed"
	echo "===================== Channel '$CHANNEL_NAME' created ===================== "
	echo
}

joinChannel () {
	for org in 1 2; do
	    for peer in 0 1; do
		joinChannelWithRetry $peer $org
		echo "===================== peer${peer}.org${org} joined channel '$CHANNEL_NAME' ===================== "
		sleep $DELAY
		echo
	    done
	done
}

## Create channel
echo "Creating channel..."
createChannel

## Join all the peers to the channel
echo "Having all peers join the channel..."
#joinChannel
joinChannelWithRetry 0 1
joinChannelWithRetry 0 2
joinChannelWithRetry 0 3
joinChannelWithRetry 0 4
joinChannelWithRetry 0 5

## Set the anchor peers for each org in the channel
echo "Updating anchor peers for buyer..."
updateAnchorPeers 0 1
echo "Updating anchor peers for seller..."
updateAnchorPeers 0 2
echo "Updating anchor peers for buyerbank..."
updateAnchorPeers 0 3

echo "Updating anchor peers for sellerbank..."
updateAnchorPeers 0 4
echo "Updating anchor peers for port..."
updateAnchorPeers 0 5

echo
echo "========= Install CHAINCODE on Buyer Org and Seller Org and instantiate on Buyer!!! =========== "
echo

## Install chaincode on Buyer Organization
echo "Installing chaincode BuyerMSP"
installChaincode 0 1

echo "Installing chaincode SellerMSP"
installChaincode 0 2

echo "Installing chaincode BuyerBankMSP"
installChaincode 0 3

echo "Installing chaincode SellerBankMSP"
installChaincode 0 4

echo "Installing chaincode PortMSP"
installChaincode 0 5


# Instantiate chaincode
echo "Instantiating chaincode on BuyerMSP"
instantiateChaincode 0 1

# Instantiate chaincode on peer0.org2
#echo "Instantiating chaincode on peer0.org2..."
#instantiateChaincode 0 2

# Query chaincode on peer0.org1
#echo "Querying chaincode on peer0.org1..."
#chaincodeQuery 0 1 100

# Invoke chaincode on peer0.org1 and peer0.org2
#echo "Sending invoke transaction on peer0.org1 peer0.org2..."
#chaincodeInvoke 0 1 0 2

## Install chaincode on peer1.org2
#echo "Installing chaincode on peer1.org2..."
#installChaincode 1 2

# Query on chaincode on peer1.org2, check if the result is 90
#echo "Querying chaincode on peer1.org2..."
#chaincodeQuery 1 2 90





echo
echo "========= All GOOD, BYFN execution completed =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

exit 0
