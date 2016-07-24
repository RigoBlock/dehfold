//GNU GENERAL PUBLIC LICENSE
//sol HF
//contract for investment fund.
// @authors:
//    Gabriele Rigo <gabriele.rigo@gmail.com>
// Copyright 2016 Gabriele Rigo.

// HF is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// HF is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with HF.  If not, see <http://www.gnu.org/licenses/>.


contract owned {
    address public owner;

    function owned() {
        owner = tx.origin;
    }

    modifier onlyOwner {
     if (msg.sender == owner)
      _
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract Drago is owned { 
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public sellPrice;
    uint256 public buyPrice;

    mapping (address => uint256) public balanceOf; 

    event Transfer(address indexed from, address indexed to, uint256 value);

    function Drago(string _dragoName,  string _dragoSymbol) {
        name = _dragoName;    
        symbol = _dragoSymbol;
    }
	
	function() {
		throw;
    }

    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
        sellPrice = newSellPrice*(10**(18 - 4));
        buyPrice = newBuyPrice*(10**(18 - 4));
    }

    function buy() returns (uint amount) {
        amount = msg.value / buyPrice;
        balanceOf[msg.sender] += amount;
        Transfer(0, msg.sender, amount);
        Transfer(this, msg.sender, amount);
		return amount;
    }

    function sell(uint amount) returns (uint revenue) {
        if (balanceOf[msg.sender] < amount ) throw;
        balanceOf[msg.sender] -= amount;
		revenue = amount * sellPrice;
        msg.sender.send(revenue);
        Transfer(msg.sender, 0, amount);
		return revenue;
    }
}   

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

contract DragoFactory is DragoRegistry {
	mapping(address => address[]) public created;
	mapping(uint => Drago) deployedContracts;
    uint numDragos;
	uint numContracts;
	uint public version = 1;
	uint[] dragoIDs;
	address[] newDragos;
    event DragoCreated(string _dragoName, address _drago, address _owner);
    
	function DragoFactory (/*address drago*/) {
		//drago = _drago; ???
		//dragoID = _dragoID; ???
    }
	
    function createDrago(string _name, string _symbol) returns (address drago) {
		Drago newDrago = (new Drago(_name, _symbol));
		newDragos.push(address(newDrago));
		//created[msg.sender].push(address(newDrago));
		//newDragos.push(address(newDrago);
        Drago(drago).transferOwnership(tx.origin);
        register(numContracts, drago);
        DragoCreated(_name, drago, tx.origin);
		return address (new Drago(_name, _symbol));
        
        //deployedContracts[numContracts] = new Drago(_dragoName, _dragoSymbol);
        //numContracts++;
		
		//return address(new Drago(_dragoName, dragoSymbol));
        //drago = new Drago(_dragoName, dragoSymbol);
        //address newDrago = new Drago(_dragoName, _dragoSymbol);    //create a new dragofund
        //newDragos.push(newDrago);
        //Drago(drago).transferOwnership(tx.origin);             //set the owner to whoever called the function (msg.sender)originally
        //register(numDragos, drago);
        //DragoCreated(_dragoName, drago, tx.origin);
    }
    
	/*function getID (uint i) {
    Drago con = Drago(newDragos[i]);
    dragoIDs[i] = con.dragoID();
}*/
	
    function() {
        throw;     // Prevents accidental sending of ether to the factory
    }
}
