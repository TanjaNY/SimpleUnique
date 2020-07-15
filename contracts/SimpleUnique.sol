pragma solidity ^0.5.0;

/*
*    Simple Example of an unique non fungible ERC-721 token
*    https://medium.com/crypto-currently/the-anatomy-of-erc721-e9db77abfc24
*/


contract SimpleUnique {

    address owner;
    uint256 totalCoins;
    //mapping( address => uint ) private balances;                                /* wieviele Tokens hat die Adresse? */
    mapping( address => uint256[] ) private tokensPerOwner;
    mapping( uint256 => address ) private whoHastoken;                          /* wer hat das Token x ? */
    mapping( address => mapping ( address => uint256 )) private allowed;        /* darf sich das Token holen */

    constructor() public {
        owner = msg.sender;
        totalCoins = 0;
    }

    // --- Description ---
    function name() public pure returns (string memory) {
        return "NodeAndCode";
    }

    function symbol() public pure returns (string memory) {
        return "NACU";
    }

    function totalSupply() public view returns (uint256) {
        return totalCoins;
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
    function mintToken(uint256 _tokenId) public {
        require( msg.sender == owner );
        require( _tokenId > 0 );
        require( whoHastoken[_tokenId] == address(0) );

        tokensPerOwner[owner].push(_tokenId);
        whoHastoken[_tokenId] = owner;
        totalCoins++;
    }


    // --- search token in owner's list ---
    function _searchToken( address _owner, uint256 _tokenId ) private view returns (uint256) {
        uint256 n = 0;
        while (n < tokensPerOwner[_owner].length && tokensPerOwner[_owner][n] != _tokenId) {
          n++;
        }
        if ( tokensPerOwner[_owner][n] == _tokenId ) {
          return n;  // --- gefunden  ---
        }
        else {
          return 0; // nicht gefunden
        }
    }

    // --- Ownership Transfer ---
    function _transfer( address _from, address _to, uint256 _tokenId ) private {
      uint256 pos = _searchToken( _from, _tokenId);
      uint256 cnt = tokensPerOwner[_from].length - 1;

      require( tokensPerOwner[_from][pos] == _tokenId ); // --- gefunden  ---

      tokensPerOwner[_from][pos] = tokensPerOwner[_from][cnt];
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
        require( newOwner != ownerOf(_tokenId) );
        require( newOwner != address(0) );

        _transfer(currentOwner, newOwner, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public {
        require( msg.sender == ownerOf(_tokenId) );
        require( msg.sender != _to );

        allowed[msg.sender][_to] = _tokenId;
        emit Approval(msg.sender, _to, _tokenId);
    }


    function takeOwnership(uint256 _tokenId) public {
        address currentOwner = ownerOf(_tokenId);
        address newOwner = msg.sender;

        require( newOwner != currentOwner );
        require( allowed[currentOwner][newOwner] == _tokenId );

        _transfer(currentOwner,newOwner,_tokenId);
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
}
