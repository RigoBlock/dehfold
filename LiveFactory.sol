contract TheContractFactory is LiveFactory {
  function uploadCode(string identifier, bytes o_code)
           onlyOrNone(deployer[identifierHash(identifier)])
           returns (bytes32) {
           
    bytes32 h = identifierHash(identifier);

    code[h] = o_code;
    deployer[h] = msg.sender;

    NewCode(identifier);
    return h;
  }

  function deploy(string identifier) {
    bytes c = code[identifierHash(identifier)];
    if (c.length == 0) throw;

    NewContract(deployCode(c), msg.sender, identifier);
  }

  function identifierHash(string identifier) returns (bytes32) {
    return sha3(identifier);
  }
  
  modifier onlyOrNone(address x) {
    if (x != 0x0 && x != msg.sender) throw;
    _;
  }

  mapping (bytes32 => address) public deployer;
  mapping (bytes32 => bytes) public code;

  event NewContract(address x, address indexed owner, string identifier);
  event NewCode(string identifier);
}
