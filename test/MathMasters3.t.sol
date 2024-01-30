// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.3;

import {Base_Test, console2} from "./Base_Test.t.sol";
import {MathMasters} from "src/MathMasters.sol";
import {SymTest} from "lib/halmos-cheatcodes/src/SymTest.sol";

contract MathMastersTest3 is Base_Test {
    // Set up the test environment
    function setUp() public pure {
        uint256 x;
        vm.assume(x < 1);
    }

    function check_sqrtCalculationWithSetup(uint256 x) public {
        assertLt(MathMasters.sqrt(x), x); // assert that sqrt(x) < x
    }
}
