// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import "./erc721-nft.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Market {
    IERC20 public erc20;
    IERC721 public erc721;

    bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
    listNFTItem[] private   ListedNFTs;
    uint256 public  Rate;//It means 1 wei can be how mach erc20 tokens

    struct Order {
        address seller;
        uint256 tokenId;
        uint256 price;
    }

    mapping(uint256 => Order) public orderOfId;
    Order[] public orders;
    mapping(uint256 => uint256) public idToOrderIndex;

    event Deal(address seller, address buyer, uint256 tokenId, uint256 price);
    event NewOrder(address seller, uint256 tokenId, uint256 price);
    event PriceChanged(address seller, uint256 tokenId, uint256 previousPrice, uint256 price);
    event OrderCancelled(address seller, uint256 tokenId);

    struct listNFTItem {
        uint256 tokenId;
        address owner;
        uint price;
    }

    function listNFT(uint256 tokenId, uint _NFTprice) public {
        address ownerAddr = erc721.ownerOf(tokenId);
        require(ownerAddr == msg.sender, "only owner can ListNft");
        listNFTItem memory newItem = listNFTItem(tokenId, ownerAddr, _NFTprice);
        ListedNFTs.push(newItem);
    }

    function getListedNFTs() public view returns (listNFTItem[] memory){
        return ListedNFTs;
    }

    function unlistNFT(uint256 tokenId) public {
        for (uint256 i = 0; i < ListedNFTs.length; i++) {
            if (ListedNFTs[i].tokenId == tokenId) {
                require(ListedNFTs[i].owner == msg.sender, "only owner can unListNFT");
                if (i < ListedNFTs.length - 1) {
                    ListedNFTs[i] = ListedNFTs[ListedNFTs.length - 1];
                }
                ListedNFTs.pop();
                break;
            }
        }
    }

    function refeshOwner(uint256 tokenId) private {
        for (uint256 i = 0; i < ListedNFTs.length; i++) {
            if (ListedNFTs[i].tokenId == tokenId) {
                ListedNFTs[i].owner = erc721.ownerOf(tokenId);
                break;
            }
        }
    }

    function getNFTPrice(uint256 tokenId) public view returns (uint256 price){
        for (uint256 i = 0; i < ListedNFTs.length; i++) {
            if (ListedNFTs[i].tokenId == tokenId) {
                return ListedNFTs[i].price;
            }
        }
        return 0;
    }

    function buyNFT(uint tokenId) public payable {
        uint256 price = getNFTPrice(tokenId);
        (uint256 truePrice, )= saveMutiply(price, Rate);

        require(msg.value >= truePrice, "Insufficient payment");

        address payable owner = payable(erc721.ownerOf(tokenId));
        require(owner != address(0), "Invalid token");

       
        erc721.safeTransferFrom(owner, msg.sender, tokenId);
        owner.transfer(msg.value);
         refeshOwner(tokenId);
    }

    function changeNFTPrice(uint256 tokenId, uint _NFTprice) public {
        for (uint256 i = 0; i < ListedNFTs.length; i++) {
            if (ListedNFTs[i].tokenId == tokenId) {
                require(ListedNFTs[i].owner == msg.sender, "only owner can changeNFT price");
                ListedNFTs[i].price = _NFTprice;
                break;
            }
        }
    }


    constructor(address _erc20, address _erc721,uint256 rate){
        require(_erc20 != address(0), "zero address");
        require(_erc721 != address(0), "zero address");
        erc20 = IERC20(_erc20);
        erc721 = IERC721(_erc721);
        Rate=rate;
    }
    function buy(uint256 _tokenId) external {
        address seller = orderOfId[_tokenId].seller;
        address buyer = msg.sender;
        uint256 price = orderOfId[_tokenId].price;
        require(erc20.transferFrom(buyer, seller, price), "transfer not successful");
        erc721.safeTransferFrom(address(this), buyer, _tokenId);
        emit Deal(seller, buyer, _tokenId, price);
    }

   

    // function changePrice(uint256 _tokenId, uint256
    //     _price) external {
    //     address seller = orderOfId[_tokenId].seller;
    //     require(msg.sender == seller, "not seller");
    //     uint256 previousPrice = orderOfId
    //     [_tokenId].price;
    //     orderOfId[_tokenId].price = _price;

    //     Order storage order = orders [idToOrderIndex[_tokenId]];
    //     order.price = _price;

    //     emit PriceChanged(seller, _tokenId,
    //         previousPrice, _price);

    // }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4){
        uint256 price = toUint256(data, 0);
        require(price > 0, "price must be greater than 0");
        orders.push(Order(from, tokenId, price));
        orderOfId[tokenId] = Order(from, tokenId, price);
        idToOrderIndex[tokenId] = orders.length - 1;
        emit NewOrder(from, tokenId, price);
        return MAGIC_ON_ERC721_RECEIVED;
    }

    function createNFT(string memory uri)external{
        
    }
    function saveMutiply(uint256 A,uint256 B) internal pure  returns (uint256 result,bool _isOverflow){
        uint tempResult = A*B;
        if((tempResult/B)==A){
            return (tempResult,false);
        }else {
            return (type(uint256).max,true);
        } 
    }

    

    function toUint256(
        bytes memory _bytes,
        uint256 _start
    ) public pure returns (uint256){
        require(_start + 32 >= _start, "Market:toUint256_overflow");
        require(_bytes.length >= _start + 32, "Market: toUint256_outOfBounds");
        uint256 tempUint;
        assembly {
            tempUint := mload (add(add(_bytes, 0x20), _start))
        }
        return tempUint;

    }
}
