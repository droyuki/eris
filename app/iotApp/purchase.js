'use strict'
// Get 'eris-contracts'.
var erisContracts = require('eris-contracts');
// Get 'eris-db' (the javascript API for eris-db)
var erisdbModule = require("eris-db");
// Create a new instance of ErisDB that uses the given URL.
var erisdb = erisdbModule.createInstance("http://140.119.19.234:1337/rpc");
// The private key.
var accountData = require('./account.json');
// Create a new pipe. 
var pipe = new erisContracts.pipes.DevPipe(erisdb, accountData);
// Create a new contracts object using that pipe.
var contractManager = erisContracts.newContractManager(pipe);

// var erisC = require('eris-contracts');
// var contractData = require('./epm.json');
// var address = contractData["deployPurchase"];
// var fs = require('fs');
// var abi = JSON.parse(fs.readFileSync("./abi/" + address));
// var account = require('./accounts.json');
// var chainUrl = "http://140.119.19.230:1337/rpc";
// var manager, contractFactory;
// manager = erisC.newContractManagerDev(chainUrl, account.advchain_full_000);
var contract = contractManager.newContractFactory(abi).at(address)
function bid(){
	contract.bid(function(err, res){
		if(err){ throw err;}
	});
}