contract DragoRegistry {
    
    address public drago;
	uint public dragoID;
	
    mapping(uint => address) public dragos;
    mapping(address => uint) public toDrago;
    
    
    function register(uint _dragoID, address _drago) {
        dragos[_dragoID] = _drago;
        toDrago[_drago] = _dragoID;
    }
    
    function accountOf(uint _dragoID) constant returns (address) {
        return dragos[_dragoID];
    }
    
    function dragoOf(address _drago) constant returns (uint) {
        return toDrago[_drago];
    }
}
