//! Hedge Fund contract.
//! By Gabriele Rigo (Rigo Investment), 2016.
//! Released under the Apache Licence 2.

import "StandardDrago.sol";

contract HumanStandardDrago is StandardDrago {
    
    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = 'H0.1';
    
    function HumanStandardDrago(string _dragoName,  string _dragoSymbol/*, uint8 _decimalUnits*/) {
        name = _dragoName;    
        symbol = _dragoSymbol;
        //decimals = _decimalUnits;
    }
    
    function() {
		throw;
    }	
}
