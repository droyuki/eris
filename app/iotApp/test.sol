contract testManager{
	address qa;
	uint value;
	function testManager(){
		qa = msg.sender;
	}
	function setPrepaid() {
		value = msg.value;
	}
	function getValue() returns(uint val){
		return value;
	}
}