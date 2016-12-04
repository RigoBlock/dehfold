// Copyright 2016 Gabriele Rigo
// Investment Vehicle contract.
// by Gabriele Rigo <gabriele@rigoinvestment.com>
// Released under the Apache Licence 2.

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

contract Drago is owned { 
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public sellPrice;
    uint256 public buyPrice;

    mapping (address => uint256) public balanceOf;
    mapping (address => bool) public approvedAccount; 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event ApprovedFunds (address target, bool approved);

    function newDrago( string tokenName,  string tokenSymbol) { 
        name = tokenName;    
        symbol = tokenSymbol;
    }
	
	function() {
		throw;
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


/// @title A campaign account contribution forwarding contract
/// @author Gabriele Rigo <gabriele.rigo@gmail.com>
contract CampaignAccount {
    address public drago;
    uint public campaignID;
    
    function CampaignAccount (address _drago, uint _campaignID) {
        drago = _drago;
        campaignID = _campaignID;
    }
}

contract CampaignAccountRegistry {
    address public drago;
    mapping(uint => address) public accounts;
    mapping(address => uint) public toCampaign;
    
    
    
    function register(uint _campaignID, address _account) {
        accounts[_campaignID] = _account;
        toCampaign[_account] = _campaignID;
    }
    
    function accountOf(uint _campaignID) constant returns (address) {
        return accounts[_campaignID];
    }
    
    function campaignOf(address _account) constant returns (uint) {
        return toCampaign[_account];
    }
}

contract CampaignAccountFactory is CampaignAccountRegistry {
	uint public version = 1;
    event AccountCreated(uint _campaignID, address _account, address _owner);
    
    function CampaignAccountFactory (address _drago) {
        drago = _drago;
    }
    
    function newCampaignAccount(uint _campaignID) returns (address account) {
        account = new CampaignAccount(drago, _campaignID);
        register(_campaignID, account);
        AccountCreated(_campaignID, account, msg.sender);
    }
}
