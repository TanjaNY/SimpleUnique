pragma solidity ^0.5.0;

/*
*    Simple Example of an unique non fungible ERC-721 token
*    https://medium.com/crypto-currently/the-anatomy-of-erc721-e9db77abfc24
*/


contract SimpleUnique {
    address owner;
    uint256 totalTokens;
    string nameToken;
    string symbolToken;
    mapping( address => uint256[] ) private tokensPerOwner;
    mapping( uint256 => address ) private whoHastoken;                          /* who owns that token */
    mapping( address => mapping ( uint256 => address )) private allowed;        /* who can fetch this token */
    mapping( uint256 => string ) private metaData;

    constructor(string memory _name, string memory _symbol) public {
        owner = msg.sender;
        totalTokens = 0;
        nameToken = _name;
        symbolToken = _symbol;
    }

    // --- Description ---
    function name() public view returns (string memory) {
        return nameToken;
    }

    function symbol() public view returns (string memory) {
        return symbolToken;
    }

    function totalSupply() public view returns (uint256) {
        return totalTokens;
    }


    // --- My Tokens ---
    function balanceOf(address _owner) public view returns (uint) {
        return tokensPerOwner[_owner].length;
    }


    // --- Who has a particular token ---
    function ownerOf(uint256 _tokenId) public view returns (address) {
        require(whoHastoken[_tokenId] != address(0));

        return whoHastoken[_tokenId];
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _idx) public view returns (uint256) {
      return tokensPerOwner[_owner][_idx];
    }


    // --- Mint Token ---
    function mintToken(uint256 _tokenId, string memory _metaData) public {
        require( msg.sender == owner );
        require( _tokenId > 0 );
        require( whoHastoken[_tokenId] == address(0) );

        tokensPerOwner[owner].push(_tokenId);
        whoHastoken[_tokenId] = owner;
        totalTokens++;

        metaData[_tokenId] = _metaData;
    }


    // --- search token in owner's list ---
    function _searchToken( address _owner, uint256 _tokenId ) private view returns (int256) {
        uint256 n = 0;
        while (n < tokensPerOwner[_owner].length && tokensPerOwner[_owner][n] != _tokenId) {
          n++;
        }
        if ( tokensPerOwner[_owner][n] == _tokenId ) {
          return int256(n);  // --- token found in list  ---
        }
        else {
          return -1; // --- token not found --- 
        }
    }

    // --- Ownership Transfer ---
    function _transfer( address _from, address _to, uint256 _tokenId ) private {
      int256 pos = _searchToken( _from, _tokenId);
	  require( pos >= 0 && pos < 2**255 - 1 );
      uint256 cnt = tokensPerOwner[_from].length - 1;
      require( tokensPerOwner[_from][uint256(pos)] == _tokenId ); // --- gefunden  ---
	  
      tokensPerOwner[_from][uint(pos)] = tokensPerOwner[_from][cnt];
      delete tokensPerOwner[_from][cnt];
      tokensPerOwner[_from].length--;
      tokensPerOwner[_to].push(_tokenId);

      whoHastoken[_tokenId] = _to;

      emit Transfer(_from, _to, _tokenId);
    }

    function transfer( address _to, uint256 _tokenId ) public {

        address currentOwner = msg.sender;
        address newOwner = _to;

        require( whoHastoken[_tokenId] != address(0) );
        require( currentOwner == ownerOf(_tokenId));
        require( newOwner != ownerOf(_tokenId) );
        require( newOwner != address(0) );

        _transfer(currentOwner, newOwner, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        require( msg.sender == ownerOf(_tokenId) );
        require( msg.sender != _to );

        allowed[msg.sender][_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }


    function takeOwnership(uint256 _tokenId) public {
        address currentOwner = ownerOf(_tokenId);
        address newOwner = msg.sender;

        require( newOwner != currentOwner );
        require( allowed[currentOwner][_tokenId] == newOwner );

        _transfer(currentOwner,newOwner,_tokenId);
    }

	function getApproved(uint256 _tokenId) public view returns (address) {
        address currentOwner = ownerOf(_tokenId);
		return allowed[currentOwner][_tokenId];
	}

    function tokenMetadata(uint256 _tokenId) public view returns (string memory) {
        return metaData[_tokenId];
    }


    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
}
