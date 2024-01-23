//获取已部署的合约
const ethers = require("ethers")

/**
 *
 * @param contractAddress 部署的线上合约地址
 * @param contractABI 合约编译后的abi文件，一般在合约源码目录下的artifacts目录下叫做 xxxmetadata.json
 * @returns {Promise<Contract>}
 */
async function getContract(contractAddress,contractABI){
    await window.ethereum.request({method: 'eth_requestAccounts'});
    const provider = new ethers.BrowserProvider( window.ethereum);
    let sginer=await provider.getSigner()
    const contract =  new ethers.Contract(contractAddress, contractABI, sginer);
    return contract
}
export {getContract};

