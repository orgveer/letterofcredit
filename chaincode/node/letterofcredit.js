/*
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
*/

'use strict';
const shim = require('fabric-shim'); // we are interacting with the fabric
const util = require('util');

var Chaincode = class {

  async Init(stub) {
    console.info('=========== Instantiated letterofcredit chaincode ===========');
    console.info('=========== START BUILDING CAHINCODE NOW!!! ===========');
    return shim.success();
  }

  async Invoke(stub) {
    // To call many functions
  }

};

shim.start(new Chaincode());
