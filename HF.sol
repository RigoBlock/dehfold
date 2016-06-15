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
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract MyToken is owned { 
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public sellPrice;
    uint256 public buyPrice;

    mapping (address => uint256) public balanceOf;
    mapping (address => bool) public approvedAccount; 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event ApprovedFunds (address target, bool approved);

    function MyToken( string tokenName,  string tokenSymbol) { 
        name = tokenName;    
        symbol = tokenSymbol;
    }
	
	function() {
		throw;
    }

    function approveAccount(address target, bool approve) onlyOwner {
        approvedAccount[target] = approve;
        ApprovedFunds(target, approve);
    }

    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
        sellPrice = newSellPrice*(10**(18 - 4));
        buyPrice = newBuyPrice*(10**(18 - 4));
    }

    function buy() returns (uint amount) {
		if (!approvedAccount[msg.sender]) throw;
        amount = msg.value / buyPrice;
        balanceOf[msg.sender] += amount;
        Transfer(0, msg.sender, amount);
        Transfer(this, msg.sender, amount);
		return amount;
    }

    function sell(uint amount) returns (uint revenue) {
		if (!approvedAccount[msg.sender]) throw;
        if (balanceOf[msg.sender] < amount ) throw;
        balanceOf[msg.sender] -= amount;
		revenue = amount * sellPrice;
        msg.sender.send(revenue);
        Transfer(msg.sender, 0, amount);
		return revenue;
    }
}   
