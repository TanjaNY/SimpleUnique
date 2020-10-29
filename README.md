# SimpleUnique

## A simple browser for ERC721 tokens

Metamask can handle fungible ERC 20 tokens quite well but has only rudimentary support for non fungible tokens such as ERC 721.

SimpleUnique is a single page Node.JS application to handle a simple ERC 721 contract using Metamask or a locally installed Ethereum client. To simplify usage and experimenting, it contains its own Solidity contract which should be deployed on an Ethereum network - private or public - using Truffle.

## Functions

* Mint tokens using mintToken(id,'MetadataString') - using Truffle UI - not implemented in Web interface

* see your tokens whith their meta data in List (account taken from MetaMask)

* send tokens to someone else (who can subsequently see them in his/her list) 

* *approve* your token to be taken by someone else (enter address and press approve) - partner should enter the tokenId in the row below the list and press *<fetch>*

* sends Solidity events to notice and update the UI


## Contract Methods

* name
* symbol
* totalSupply
* balanceOf
* ownerOf
* tokenOfOwnerByIndex
* mintToken
* transfer
* approve
* takeOwnership
* getApproved
* tokenMetadata

## Caveats

* minting new tokens not yet via Web interface

* Solidity Contract hard coded using Truffle. 

* some extended ERC721 methods not implemented yet in underlying contract (safeTransferFrom, approvalForAll etc.)

* MetaMask for Android has a very basic ERC721 interface which shows tokens held by a given contract address after entered manually. Sending from that interface fails with an generic error message. (but at least we see that whe token is there)
