import "Drago.sol";

contract StandardDrago is Drago {
    
    uint256 public sellPrice;
    uint256 public buyPrice;
    
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyDragowner {
        sellPrice = newSellPrice*(10**(18 - 4));
        buyPrice = newBuyPrice*(10**(18 - 4));
    }
    
    function buy(address _from, uint _value, address _to) returns (uint amount, bool success) {
        //token leaves totalSupply unlimited, can be over max (2^256 - 1).
        //token leaves out totalSupply and can issue more tokens as time goes on, need to check if it doesn't wrap.
        if (balances[msg.sender] >= _value && balances[_from] + _value > balances[_from]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
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
    
    function balanceOf(address _Dragowner) constant returns (uint256 balance) {
        return balances[_Dragowner];
    }
    
    mapping (address => uint256) balances;
	
}
