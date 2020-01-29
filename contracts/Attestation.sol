pragma solidity >=0.4.22 <0.6.0;

contract Attestation {
    address payable public owner;
    uint latestDocument;
    mapping(uint => DocumentTransfer) public history;
    mapping(bytes32 => bool) public usedHashes;
    mapping(bytes32 => address) public documentHashMap;

    event DocumentEvent(uint blockNumber, bytes32 indexed hash, address indexed from, address indexed to);
    event Deposit(address indexed sender, uint value);

    struct DocumentTransfer {
        uint blockNumber;
        bytes32 hash;
        address from;
        address to;
    }

    modifier onlyOwner() {
        //if (msg.sender == owner)
        require(msg.sender == owner, "Only owner has permissions");
        _;
    }

    /// @dev Fallback function allows to deposit ether.
    function() external payable {
        //revert("Reverting... fallback function");
        if (msg.value > 0)
            emit Deposit(msg.sender, msg.value);
    }

    constructor() public {
        owner = msg.sender;
    }

    // In case you sent funds by accident
    function withdrawFunds() public onlyOwner{
        uint256 balance = address(this).balance;
        address(owner).transfer(balance);
    }

    function newDocument(bytes32 hash) public returns (bool success){
        if (documentExists(hash)) {
            success = false;
        }
        else {
            createHistory(hash, msg.sender, msg.sender);
            usedHashes[hash] = true;
            success = true;
        }
        return success;
    }
    function createHistory (bytes32 hash, address from, address to) internal {
            ++latestDocument;
            documentHashMap[hash] = to;
            usedHashes[hash] = true;
            history[latestDocument] = DocumentTransfer(block.number, hash, from, to);
            emit DocumentEvent(block.number, hash, from,to);
    }

    function transferDocument(bytes32 hash, address recipient) public returns (bool success){
        success = false;

        if (documentExists(hash)){
            if (documentHashMap[hash] == msg.sender){
                createHistory(hash, msg.sender, recipient);
                success = true;
            }
        }

        return success;
    }

    function documentExists(bytes32 hash) public view returns (bool exists){
        if (usedHashes[hash]) {
            exists = true;
        }else{
            exists = false;
        }
        return exists;
    }

    function getDocument(uint docId) public view returns (uint blockNumber, bytes32 hash, address from, address to){
        DocumentTransfer memory doc = history[docId];
        blockNumber = doc.blockNumber;
        hash = doc.hash;
        from = doc.from;
        to = doc.to;
    }

    function getLatest() public view returns (uint latest){
        return latestDocument;
    }
}
