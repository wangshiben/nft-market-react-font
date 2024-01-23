// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract cUSDT is ERC20 {
    constructor()
        ERC20("Test ERC20", "cUSDT"){
        _mint(msg.sender,1*10**8*10**18);
        //0x5FBDB2315678AFECB367F032D93F642F64180AA3
    }
    function safeMint(address to,uint256 value) external  returns (bool) {
        _mint(to, value);
        return true;
    }
}