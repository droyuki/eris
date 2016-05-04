contract Purchase{
	address owner;
	uint buyerBalance;
	enum State { Created, Locked, Inactive }
	State public state;
	function Purchase(){
		owner = msg.sender;
		state = State.Created;
	}
	function getBalance() returns (uint res){
		return buyerBalance;
	}
	function prepay() returns (uint res){
	    if (msg.value == 0){
            return 0;
        }
		buyerBalance += msg.value;
		state = State.Locked;
		return buyerBalance;
	}
	function deduct(uint price) returns (uint res){
		if(buyerBalance < price){
			return 0;
		}
		buyerBalance -= price;
		return buyerBalance;
	}
	function refund() returns (bool res){
		if(buyerBalance == 0){
			return false;
		}
		msg.sender.send(buyerBalance);
		return true;
	}
}

contract iotManager{
    address seller;
    // This holds a reference to the current purchase contract.
    // address pAddr;
    mapping (address => address) clientData;
	mapping (address => uint) buyerBalance;
	mapping (address => string) buyerResult;
	uint prepayValue;
    modifier onlySeller() {
        if (msg.sender != seller) throw;
        _
    }
    function iotManager(){
    	seller = msg.sender;
    }
    function getOrCreatePurchase() returns (address res){
        if(clientData[msg.sender] == 0x0){
            address pAddr = new Purchase();
        	clientData[msg.sender] = pAddr;
        }
    	return clientData[msg.sender];
    }
	function setPrepay(uint price) onlySeller returns (uint res){
		prepayValue = price;
		return prepayValue;
	}
	// Use the interface to call on the Purchase contract. We pass msg.value along as well.
 	function prepay() returns (uint result){
 	    address pAddr = clientData[msg.sender];
		if (msg.value == 0){
            return 0;
        }
		if (pAddr == 0x0 ) {
			//If the user sent money, we should return it if we can't prepaid.
			msg.sender.send(msg.value);
			return 0;
		}
		if(msg.value < prepayValue){
		    msg.sender.send(msg.value);
			return 0;
		}
		uint res = Purchase(pAddr).prepay.value(msg.value)();
		// If the transaction failed, return money to the caller.
        if(res == 0){
            msg.sender.send(msg.value);
        }
        buyerBalance[msg.sender] += msg.value;
        return res;
	}
	function getBalance(address client) onlySeller returns (uint res){
	    address pAddr = clientData[client];
		uint blnc = Purchase(pAddr).getBalance();
		return blnc;
	}
	function checkPrepay(address client) onlySeller returns (bool result){
	    address pAddr = clientData[client];
		if(buyerBalance[client] <= prepayValue){
			return false;
		}
		uint balanceInP = Purchase(pAddr).getBalance();
		if(buyerBalance[client] != balanceInP){
			return false;
		}
		return true;
	}
	function deduct(address buyer, uint price) onlySeller returns (bool res){
		if(buyerBalance[buyer] < price){
			return false;
		}
		address pAddr = clientData[buyer];
		uint newBuyerBalance = Purchase(pAddr).deduct(price);
		buyerBalance[buyer] = newBuyerBalance;
		return true;
	}
	function refund(address buyer) onlySeller returns (bool result){
	    address pAddr = clientData[buyer];
		if (pAddr == 0x0 ) {
			return false;
		}
		bool success = Purchase(pAddr).refund();
		if(!success){
			return false;
		}
		buyer.send(buyerBalance[buyer]);
        return success;
	}
	function getAddr(address client) onlySeller constant returns (address addr){
		return clientData[client];
	}
// 	function setAddr(address newAddr) onlySeller returns (bool result){
// 		pAddr = newAddr;
// 	}
	function setResult(address buyer, string result) onlySeller returns (bool res){
		if(buyerBalance[msg.sender] == 0){
			return false;
		}
		buyerResult[buyer] = result;	
		return true;	
	}
	function getResult() returns (string res){
		return buyerResult[msg.sender];
	}
}