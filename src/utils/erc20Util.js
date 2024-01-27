import erc20 from '../abi/cUSDT.json';
import {getContract} from "./ContractUtil"
import {addressExamine} from "./TypeUtil";
import ErrorEnum from "./error/ErrorEnum";
// TODO:合约地址变动加入后端
const contractAddressDefault = '0x5FbDB2315678afecb367f032d93F642f64180aa3';

const contract =  await getERC20()

async function getERC20(){
    let erc20Contract = await getContract(contractAddressDefault,erc20.output.abi)
    return erc20Contract
}

async function getErc20Balance(address) {
    if ( !addressExamine(address)) throw ErrorEnum.InvalidAddress.getError()
    let callback = await contract.balanceOf(address)
    return callback;
}
//发币函数
async function safeMint(address,value){
    if ( !addressExamine(address)) throw ErrorEnum.InvalidAddress.getError()
    if (!value){
        value="10000000000";
    }
    let callback = await contract.safeMint(address,value)
    return callback;
}
//交易函数
async function transfer(to,value){
    if ( !addressExamine(to)) throw ErrorEnum.InvalidAddress.getError()
    return  await contract.transfer(to,value)
}
//基于授权的交易函数
async function transferFrom(from,to,value) {
    if ( !addressExamine(from,to)) throw ErrorEnum.InvalidAddress.getError()
    let accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    if (accounts[0]===from){
        await Approve(from,value)
    }
    return  await contract.transferFrom(from,to,value)
}
//授权函数调用
async function Approve(approveAddress,value){
    if ( !addressExamine(approveAddress)) throw ErrorEnum.InvalidAddress.getError()
    return await contract.approve(approveAddress,value)
}
async function Allowance(owner,spender){
    if ( !addressExamine(owner,spender)) throw ErrorEnum.InvalidAddress.getError()
    return await contract.allowance(owner,spender)
}





export  {getErc20Balance,safeMint,transfer,transferFrom,Approve,Allowance};
