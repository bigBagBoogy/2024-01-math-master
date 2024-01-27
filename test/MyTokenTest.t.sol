// SPDX-License-Identifier: MIT

pragma solidity ^0.8.3;

import {SymTest} from "lib/halmos-cheatcodes/src/SymTest.sol";
import {MyToken} from "src/MyToken.sol";
import {Test} from "lib/forge-std/src/Test.sol";

contract MyTokenTest is SymTest, Test {
    MyToken tokenContract;

    function setUp() public {
        uint256 initialSupply = svm.createUint256("initialSupply");
        tokenContract = new MyToken(initialSupply);
    }

    function check_transfer(address sender, address receiver, uint256 amount) public {
        // specify input conditions
        vm.assume(receiver != address(0));
        vm.assume(address(sender) != address(receiver));
        vm.assume(tokenContract.balanceOf(sender) >= amount);

        // record the current balance of sender and receiver
        uint256 balanceOfSender = tokenContract.balanceOf(sender);
        uint256 balanceOfReceiver = tokenContract.balanceOf(receiver);

        // call target contract
        // vm.prank(sender);
        // token.transfer(receiver, amount);

        // call target contract using low-level call
        vm.prank(sender);
        (bool success,) =
            address(tokenContract).call(abi.encodeWithSelector(tokenContract.transfer.selector, receiver, amount));
        require(success, "Transfer failed");

        // check output state
        assert(tokenContract.balanceOf(sender) == balanceOfSender - amount);
        assert(tokenContract.balanceOf(receiver) == balanceOfReceiver + amount);
    }

    function check_mint(address minter, uint256 amount) public {
        // specify input conditions
        vm.assume(minter != address(0));
        // record the current balance of sender and receiver
        uint256 balanceOfMinter = tokenContract.balanceOf(minter);
        // call target contract
        vm.prank(minter);
        tokenContract.mint(minter, amount);
        // check output state
        assert(tokenContract.balanceOf(minter) == balanceOfMinter + amount);
    }
}
