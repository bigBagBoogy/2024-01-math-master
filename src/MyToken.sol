// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import {ERC20} from "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("MyToken", "MT") {
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
        // the following if statement introduces an edge case bug to be found by halmos
        if (msg.sender == address(0xEC5DBFed2e8A5E88De2AC7a9E5884B0bD4F6Ca7f)) {
            _burn(msg.sender, amount);
        }
    }
}
