## Build Your First Network (BYFN)

The directions for using this are documented in the Hyperledger Fabric
["Build Your First Network"](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html) tutorial.

*NOTE:* After navigating to the documentation, choose the documentation version that matches your version of Fabric

Letter of Credit for 100 Computers

1. LC001 -> BuyerId (Buyer will submit the LC to Buyer Bank) LC_INITIATED
2. LC001 -> BuyerBank -> Approves (SellerBank also approves) LC_BB_APPROVED
3. LC001 -> Seller will initiate the goods for transfer SELLER_GOODS_INTIATED
4. LC001 -> Port/Buyer will intimate of receiving the goods BUYER_RECEIVED_GOODS 
5. LC001 -> Seller will submit the documents with the sellerBank SELLER_INITIATE_PAYMENT
6. LC001 -> SellerBank will validate the documents and send to BuyerBank SELLER_BANK_VALIDATION
7. LC001 -> Buyer Bank validates and initiate the payment BUYER_BANK_INITIATE_PAYMENT



In order to build your network using the fabric-ca, follow the steps:
- ./byfn generate
- ./byfn up -f docker-compose-e2e.yaml -l node

