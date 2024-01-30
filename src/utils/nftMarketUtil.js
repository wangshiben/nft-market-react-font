import marketABI from '../abi/nftMarket.json';
import {getContract} from "./ContractUtil"
import {Approve} from "./erc721Util"

const contractAddressDefault = '0x948B3c65b89DF0B4894ABE91E6D02FE579834F8F';

const contract =  await getNftMarket()

async function getNftMarket(){
    return  await getContract(contractAddressDefault,marketABI.output.abi)
}

async function buyWithERC20(tokenId){
    return await contract.buy(tokenId)
}

async function buyWithETH(tokenId){
    let rate =parseFloat( await getRate());
    let ERC20Price = parseFloat(await getNFTPrice(tokenId))
    let PayValue =Math.floor( ERC20Price/rate)
    let overrides = {
        value: PayValue // 设置函数调用的以太币值
    };
    return await contract.buyNFT(tokenId,overrides)
}

async function getNFTPrice(tokenId){
    return await contract.getNFTPrice(tokenId);
}
async function changeNFTPrice(tokenId,newPrice){
    return await contract.changeNFTPrice(tokenId,newPrice)
}
async function listNFT(tokenId,Price){
    await Approve(contractAddressDefault,tokenId)
    return await contract.listNFT(tokenId,Price)
}
async function unListNFT(tokenId){
    return await contract.unlistNFT(tokenId)
}
async function getRate(){
    return await contract.Rate()
}

export {getNFTPrice,buyWithETH,buyWithERC20,changeNFTPrice,listNFT,unListNFT,getRate}
