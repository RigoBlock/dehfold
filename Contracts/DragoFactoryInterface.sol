//! Hedge Fund contract.
//! By Gabriele Rigo (Rigo Investment), 2016.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.6;

import 'HumanStandardDrago.sol'
import 'HumanStandardDragoFactory.sol'

contract DragoFactoryInterface is HumanStandardDrago, HumanStandardDragoFactory {
    
    function DragoFactoryInterface(address HumanStandardDragoFactory)  {
        
    }
        
    //allows users to interact with dragos: buydrago, selldrago, setprices
    
    function buyDrago(address _drago, address _from, uint _value) returns (uint amount, bool success) {
    //(address _from, uint _value, address _to)
        //token leaves totalSupply unlimited, can be over max (2^256 - 1). set initial price 1 ETH = 100 dragos, then only Dragowner can change price
        //token leaves out totalSupply and can issue more tokens as time goes on, need to check if it doesn't wrap.
        if (balances[msg.sender] >= _value && balances[_from] + _value > balances[_from]) {
            balances[msg.sender] -= _value;
            balances[_drago] += _value;
            amount = msg.value / buyPrice;
            balances[msg.sender] += amount; //verificare se da factory tx.origin
            Transfer(0, msg.sender, amount);
            Transfer(this, msg.sender, amount);
		    return (amount, true);
        } else { return (amount, false); } //evaluate whether necessary condition if address _from = address _standardDrago, throw
    }
    
    function sell(uint amount, address _to, address _from) returns (uint revenue, bool success) {
        if (balances[msg.sender] <= amount && balances[_to] + amount > balances[_to]) {
            balances[msg.sender] -= amount;
		    revenue = amount * sellPrice;
            msg.sender.send(revenue);
            Transfer(msg.sender, 0, amount);
		    return (revenue, true);
		    //return true;
        } else { return (revenue, false); }
    }
    
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyDragowner returns (uint256 sellPrice, uint256 buyPrice) {
        sellPrice = newSellPrice*(10**(18 - 4));
        buyPrice = newBuyPrice*(10**(18 - 4));
    }   
}
