// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract CUSDT is ERC20,Ownable {

    constructor(address initialOwner)
        ERC20("Test ERC20", "cUSDT")Ownable(initialOwner){
        _mint(msg.sender,1*10**8*10**18);
        Ownable(initialOwner);
        //0x5FBDB2315678AFECB367F032D93F642F64180AA3
    }
    function safeMint(address to,uint256 value) external  onlyOwner returns (bool) {
        _mint(to, value);
        return
        true;
    }
    function UpdateOnwer(address newAdd) public onlyOwner {
         _transferOwnership(newAdd);
    }

     function transferFrom(address from, address to, uint256 value) public override(ERC20) returns (bool) {
        address spender = _msgSender();
        if (msg.sender!=spender){_spendAllowance(from, spender, value);}
        _transfer(from, to, value);
        return true;
     }

     function Ruin(address addr, uint256 value) public onlyOwner returns(bool) {
        _burn(addr, value);
        return true;
     }
}