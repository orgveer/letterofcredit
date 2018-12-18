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
    return shim.success();
  }

  async Invoke(stub) {
    // Available across the lifecycle of the chaincode
    console.log( '============= Into Invoke ========');
    var ret = stub.getFunctionAndParameters();
    console.info('Get Function and Parameters: ' + JSON.stringify(ret));

    var method = this[ret.fcn];
    console.log( 'The method name passed in the invoke: ' + method);
    if (!method) {
      console.error('No function of name:' + ret.fcn + ' found');
      throw new Error('Received unknown function ' + ret.fcn + ' invocation');
    }

    try
    {
      var payload = await method(stub, ret.params);
      return shim.success(payload);
    }
    catch (err)
    {
      console.log(err);
      return shim.error(err);
    }
  }

  // This will create a LC document with id and description passed
  async initiate_lc(stub, args) {
    console.log( 'Into initiate_lc: ' + args);
    if ( args.length != 2) {
      throw new Error('Incorrect number of arguments. Expecting args [id] and [description].' );
    }

    var payload = {
      docType: 'lcdoc',  // Adding this to check on the couchDB implmentation -- COME back later
      state: 'LC_INITIATED',
      id: args[0],
      description: args[1]
    };
    await stub.putState(args[0], Buffer.from(JSON.stringify(payload)));
    console.info('Initiated an LC document: ', JSON.stringify(payload));
  }

  // Fetch the LC document details based on Lc Id
  async query_lc(stub, args) {
    console.log( 'Into query_lc: ' + args);

    if ( args.length != 1) {
      throw new Error('Incorrect number of arguments. Expecting args [id]');
    }

    var lc_document_bytes = await stub.getState(args[0]);
    if ( !lc_document_bytes || lc_document_bytes.toString().length <= 0) {
      throw new Error( args[0] + ' does not exist.');
    }

    console.log( lc_document_bytes.toString());
    return lc_document_bytes;
  }

  // Change the LC state
  async change_lc_state(stub, args) {
    console.log( 'Into change_lc_state: ' + args);

    if ( args.length != 2) {
      throw new Error('Incorrect number of arguments. Expecting args [id] and [state].' );
    }

    // TODO: Check the state passed is of right enum value

    var lc_document_bytes = await stub.getState(args[0]);
    if ( !lc_document_bytes || lc_document_bytes.toString().length <= 0) {
      throw new Error( args[0] + ' does not exist.');
    }

    // TODO: The state changes have to be validated accordingly

    var lc_json_object = JSON.parse(lc_document_bytes);
    lc_json_object.state = args[1];
    console.log( 'Updating the LC document with new state: ' + JSON.stringify(lc_json_object));
    await stub.putState(args[0], Buffer.from(JSON.stringify(lc_json_object)));
  }

};

shim.start(new Chaincode());
