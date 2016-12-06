//! Hedge Fund contract.
//! By Gabriele Rigo (Rigo Investment), 2016.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.6;

contract DragoRegistry {
    
    mapping(uint => address) public dragos;
    mapping(address => uint) public toDrago;
    mapping(address => address[]) public created;
    address public _drago;
    uint public _dragoID;
    bytes public humanStandardByteCode;
    
    function accountOf(uint _dragoID) constant returns (address) {
        return dragos[_dragoID];
    }
    
    function dragoOf(address _drago) constant returns (uint) {
        return toDrago[_drago];
    }
    
    function register(address _drago, uint _dragoID) {
        dragos[_dragoID] = _drago;
        toDrago[_drago] = _dragoID;
    }
}
