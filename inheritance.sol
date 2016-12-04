// This gist explains some misunderstandings about Solidity constructors parameters and inheritance

pragma solidity ^0.4.6;

// Base contract to extend
contract BaseContract {
    function BaseContract(bool myVar) {}
}

// Wrong way to extend a contract that use parameters in its own constructor
contract ExtendedContract_WrongConstructor is BaseContract {
    bool _myVar;
    function ExtendedContract_WrongConstructor(bool myVar) {
        _myVar = myVar;
    }
}

// Right way to extend a contract that use parameters in its own constructor
contract ExtendedContract_CorrectConstructor is BaseContract {
    bool _myVar;
    function ExtendedContract_CorrectConstructor(bool myVar) BaseContract(myVar){
        _myVar = myVar;
    }
}

// Test the two cases
contract Tester {
    function Tester(){
        //This does not compile
        //ExtendedContract_WrongConstructor myContract = new ExtendedContract_WrongConstructor(true); //This throws: "Error: Trying to create an instance of an abstract contract."
        
        //This compiles
        ExtendedContract_CorrectConstructor myCorrectContract = new ExtendedContract_CorrectConstructor(true);
    }
}
