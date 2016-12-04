//! Hedge Fund contract.
//! By Gabriele Rigo (Rigo Investment), 2016.
//! Released under the Apache Licence 2.

import "DragoRegistry";
import "HumanStandardDrago.sol";

contract HumanStandardDragoFactory is DragoRegistry {
	
	string public version = 'DF0.1'; //alt uint public version = 1
	uint[] _dragoID;
	address[] newDragos;
	
    event DragoCreated(string _name, address _drago, address Dragowner, uint _dragoID);
    
	function HumanStandardDragoFactory () {
	    
	    }	
	
	function createHumanStandardDrago(string _name, string _symbol) returns (address _drago, uint _dragoID) {
		HumanStandardDrago newDrago = (new HumanStandardDrago(_name, _symbol));
		newDragos.push(address(newDrago));
		created[msg.sender].push(address(newDrago));
        newDrago.transferDragownership(tx.origin);
        register(_drago, _dragoID);
        DragoCreated(_name, address(newDrago), tx.origin, uint(newDrago));
        return (address(newDrago), uint(newDrago));
    }
    
    function() {
        throw;
    }
}
