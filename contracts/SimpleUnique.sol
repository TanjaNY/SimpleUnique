pragma solidity ^0.5.0;

/*
*    Simple Example of an unique non fungible ERC-721 token 
*    https://medium.com/crypto-currently/the-anatomy-of-erc721-e9db77abfc24
*/


contract SimpleUnique {
    
    address owner;
    mapping( address => uint ) private balances;                                /* wieviele Tokens hat die Adresse? */
    mapping( uint256 => address ) private tokenOwners;                          /* wer hat das Token x ? */
    mapping( uint256 => bool ) private tokenExists;                             /* gibt es das Token x ja/nein */
    mapping( address => mapping ( uint256 => uint256 ) ) private ownerTokens;   /* welche Tokens sind auf dieser Adresse? */
    mapping( address => mapping (address => uint256 )) allowed;                  /* darf sich das Token holen */
    
    
    constructor() public {
        owner = msg.sender;
    }
    
    
    function name() public pure returns (string memory) {
        return "NodeAndCode";
    }
    
    function symbol() public pure returns (string memory) {
        return "NACU";
    }
    
    function totalSupply() public pure returns (uint256) {
        return 1000;
    }
 
 
    function balanceOf(address _owner) public view returns (uint) {
        return balances[_owner];
    }
    
    
    function ownerOf(uint256 _tokenId) public view returns (address) {
        require(tokenExists[_tokenId]);
        
        return tokenOwners[_tokenId];
    }
    
    
    function mintToken(uint256 _tokenId) public {
        require( msg.sender == owner );
        
        balances[msg.sender] += 1;
        tokenOwners[_tokenId] = msg.sender;
        tokenExists[_tokenId] = true;
    }
    
    
    function approve(address _to, uint256 _tokenId) public {
        require( msg.sender == ownerOf(_tokenId) );
        require( msg.sender != _to );
        
        allowed[msg.sender][_to] = _tokenId;
        emit Approval(msg.sender, _to, _tokenId);
    }
    
    
    function takeOwnership(uint256 _tokenId) public {
        address oldOwner = ownerOf(_tokenId);
        address newOwner = msg.sender;
        
        require( newOwner != oldOwner );
        require( allowed[oldOwner][newOwner] == _tokenId );
        balances[oldOwner] -= 1;
        tokenOwners[_tokenId] = newOwner;
        balances[newOwner] += 1;
        emit Transfer(oldOwner, newOwner, _tokenId);
    }
    
    /* bislang nicht im Einsatz 
    function removeFromTokenList(address _owner, uint256 _tokenId) private {
        for(uint256 i = 0 ; ownerTokens[_owner][i] != _tokenId ; i++ ) {  
            ownerTokens[_owner][i] = 0;
        }
    }
    */
    
    function transfer( address _to, uint256 _tokenId ) public {
        address currentOwner = msg.sender;
        address newOwner = _to;
        
        require( tokenExists[_tokenId] );
        require( newOwner != ownerOf(_tokenId) );
        require( newOwner != address(0) );
        
        balances[currentOwner] -= 1;
        tokenOwners[_tokenId] = newOwner;
        
        balances[newOwner] += 1;
        emit Transfer(currentOwner, newOwner, _tokenId);
    }
    
    
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
}
