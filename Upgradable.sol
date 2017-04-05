//! Upgradable contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.10;

contract Upgradeable {

    function initialize();
    
    function replace(address target) internal {
        _dest = target;
        target.delegatecall(bytes4(sha3("initialize()")));
    }
    
    mapping(bytes4=>uint32) _sizes;
    address _dest;
}


contract Dispatcher is Upgradeable {

    function Dispatcher(address target) {
        replace(target);
    }
    
    function initialize() {
        // Should only be called by on target contracts, not on the dispatcher
        throw;
    }

    function() {
        bytes4 sig;
        assembly { sig := calldataload(0) }
        var len = _sizes[sig];
        var target = _dest;
        
        assembly {
            // return _dest.delegatecall(msg.data)
            calldatacopy(0x0, 0x0, calldatasize)
            delegatecall(sub(gas, 10000), target, 0x0, calldatasize, 0, len)
            return(0, len)
        }
    }
}

contract Example is Upgradeable {
    uint _value;
    
    function initialize() {
        _sizes[bytes4(sha3("getUint()"))] = 32;
    }
    
    function getUint() returns (uint) {
        return _value;
    }
    
    function setUint(uint value) {
        _value = value;
    }
}

    function cancelUpdates(){
        if (!msg.sender == owner) availableUpdate = false;

    }

    function replace(address target) internal {       
        if (!availableUpdates) throw; 

        _dest = target;
        target.delegatecall(bytes4(sha3("initialize()")));
    }
