import "DragoRegistry";
import "HumanStandardDrago.sol";

contract HumanStandardDragoFactory /*is DragoRegistry*/ {
	
	mapping(address => address[]) public created;
	bytes public humanStandardByteCode;
	//mapping(uint => Drago) deployedContracts;
	
    //mapping(address => bool) public isHumanDrago; //verify without having to do a bytecode check.
    //bytes public humanStandardByteCode;
	
    //uint numDragos;
	//uint numContracts;
	//uint public version = 1;
	//uint[] dragoIDs;
	//address[] newDragos;
	
    event DragoCreated(string _name, address _drago, address _owner);
    
	function DragoFactory (/*address drago*/) {
	    address verifiedDrago = createHumanStandardDrago("Verify Drago", "VTX");
	    humanStandardByteCode = codeAt(verifiedDrago);
		//drago = _drago; ???
		//dragoID = _dragoID; ???
	}	
		
	function codeAt(address _addr) internal returns (bytes o_code) {
        assembly {
          // retrieve the size of the code, this needs assembly
          let size := extcodesize(_addr)
          // allocate output byte array - this could also be done without assembly
          // by using o_code = new bytes(size)
          o_code := mload(0x40)
          // new "memory end" including padding
          mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
          // store length in memory
          mstore(o_code, size)
          // actually retrieve the code, this needs assembly
          extcodecopy(_addr, add(o_code, 0x20), 0, size)
      }
    }
	
    function createHumanStandardDrago(string _name, string _symbol) returns (address /*drago*/) {
		HumanStandardDrago newDrago = (new HumanStandardDrago(_name, _symbol));
		created[msg.sender].push(address(newDrago));
		return address (newDrago);
		
        //newDrago.transferOwnership(tx.origin);
        //register(numContracts, drago);
        //DragoCreated(_name, _drago, tx.origin);
        
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
    
    function() {
        throw;     // Prevents accidental sending of ether to the factory
    }
}
