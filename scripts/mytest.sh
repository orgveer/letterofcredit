#Install jq

#copy a file from docker to local
#docker cp <containerId>:/file/path/within/container /host/path/target

#Fetch current config for the channel


ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/letterofcredit.com/orderers/orderer.letterofcredit.com/msp/tlscacerts/tlsca.letterofcredit.com-cert.pem

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  CORE_PEER_LOCALMSPID="OrdererMSP"
  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/letterofcredit.com/orderers/orderer.letterofcredit.com/msp/tlscacerts/tlsca.letterofcredit.com-cert.pem
  CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/letterofcredit.com/users/Admin@letterofcredit.com/msp
}

  setOrdererGlobals

  #echo "Fetching the most recent configuration block for the channel"
  #set -x
  #peer channel fetch config config_block.pb -o orderer.letterofcredit.com:7050 -c "mychannel" --tls --cafile $ORDERER_CA
  #peer channel fetch 3 config_block.pb -o orderer.letterofcredit.com:7050 -c "mychannel" --tls --cafile $ORDERER_CA
  #set +x

  #echo "Decoding config block to JSON and isolating config to config.json"
  #set -x
  #configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config >"config-3.json"
  #set +x


  set -x
  peer channel fetch 0 mychannel.block -o orderer.letterofcredit.com:7050 -c "mychannel" --tls --cafile $ORDERER_CA
  set +x

  echo "Decoding config block to JSON and isolating config to config.json"
  set -x
  configtxlator proto_decode --input mychannel.block --type common.Block | jq .data.data[0].payload.data.config >"config-genesis.json"
  set +x

#peer channel fetch 0 mychannel.block -o orderer.example.com:7050 -c $CHANNEL_NAME --tls --cafile $ORDERER_CA
