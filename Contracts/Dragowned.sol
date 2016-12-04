//! Hedge Fund contract.
//! By Gabriele Rigo (Rigo Investment), 2016.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.6;

contract Dragowned {
    address public Dragowner;

    function Dragowned() {
        Dragowner = tx.origin;
    }

    modifier onlyDragowner {
        if (msg.sender == Dragowner)
        _
    }

    function transferDragownership(address newDragowner) onlyDragowner {
        Dragowner = newDragowner;
    }
}
