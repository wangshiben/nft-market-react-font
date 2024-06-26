// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, ERC721Enumerable, Ownable {
    uint256 private _nextTokenId;
    string  private  basedURI;
    mapping(string=>string) public NameServiceToCID; 
    mapping (string=>uint256) public NameServiceToTokenId;
    mapping (uint256=>string) public TokenToNameService;
    mapping(address=>uint256[]) public addToToken;
    constructor(address initialOwner)
        ERC721("NFTM", "NFTM")
        Ownable(initialOwner)
    {}

    
    function balanceOfList (address _owner) external view returns (uint256[] memory) {
        return addToToken[_owner];
    }

    function updateOwner(address newAdd)public onlyOwner {
        _transferOwnership(newAdd);
    }

    function tokenURI(uint256 tokenId) public view override  returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return basedURI;
    }

    function safeMint(address to,string memory baseURI,string memory CID) public onlyOwner {
        basedURI=baseURI;
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        NameServiceToCID[baseURI]=CID;
        NameServiceToTokenId[baseURI]=tokenId;
        TokenToNameService[tokenId]=baseURI;
        if (addToToken[to].length == 0) {
            addToToken[to] = new uint256[](0);
        }
        addToToken[to].push(tokenId);
    }
    function ChangeCID(string memory baseURI,string memory CID)public onlyOwner {
        NameServiceToCID[baseURI]=CID;
    }

    function getCID(string memory baseURI) public view returns(string memory){
        return NameServiceToCID[baseURI];
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
