// The top level CMC
contract Doug {

    address owner;

    // This is where we keep all the contracts.
    mapping (bytes32 => address) contracts;

    function addContract(bytes32 name, address addr) {
        if(msg.sender != owner){
            return;
        }
        contracts[name] = addr;
    }

    function removeContract(bytes32 name) returns (bool result) {
        if (contracts[name] == 0x0){
            return false;
        }
        if(msg.sender != owner){
            return;
        }
        contracts[name] = 0x0;
        return true;
    }

    function getContract(bytes32 name) constant returns (address addr) {
        return contracts[name];
    }

    function remove() {
        if (msg.sender == owner){
            suicide(owner);
        }
    }

}