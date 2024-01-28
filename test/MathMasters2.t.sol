// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.3;

import {Base_Test, console2} from "./Base_Test.t.sol";
import {MathMasters} from "src/MathMasters.sol";
import {SymTest} from "lib/halmos-cheatcodes/src/SymTest.sol";

contract MathMastersTest2 is Base_Test {
    function testMemoryPointer() public {
        uint256 initialPointer = getFreeMemoryPointer();
        console2.log("Initial free memory pointer:", initialPointer);
        uint256 expectedLocation = 0x80;
        console2.log("Expexted free memory pointer:", expectedLocation);

        // Allocate memory
        uint256[] memory data = new uint256[](10);
        uint256 allocatedPointer = getFreeMemoryPointer();
        console2.log("Free memory pointer after allocation:", allocatedPointer);

        // Deallocate memory
        delete data;
        assembly {
            mstore(0x40, 0x40) // Reset free memory pointer to initial value
        }
        uint256 finalPointer = getFreeMemoryPointer();
        console2.log("Free memory pointer after deallocation:", finalPointer);
        assertEq(finalPointer, initialPointer, "Memory deallocation failed");
    }

    function getFreeMemoryPointer() public pure returns (uint256) {
        uint256 ptr;
        assembly {
            ptr := mload(0x40)
        }
        return ptr;
    }
}
