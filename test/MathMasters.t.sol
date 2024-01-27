// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.3;

import {Base_Test, console2} from "./Base_Test.t.sol";
import {MathMasters} from "src/MathMasters.sol";
import {SymTest} from "lib/halmos-cheatcodes/src/SymTest.sol";

contract MathMastersTest is Base_Test {
    function testMulWad() public {
        assertEq(MathMasters.mulWad(2.5e18, 0.5e18), 1.25e18);
        assertEq(MathMasters.mulWad(3e18, 1e18), 3e18);
        assertEq(MathMasters.mulWad(369, 271), 0);
    }

    function testMulWadFuzz(uint256 x, uint256 y) public pure {
        // Ignore cases where x * y overflows.
        unchecked {
            if (x != 0 && (x * y) / x != y) return;
        }
        assert(MathMasters.mulWad(x, y) == (x * y) / 1e18);
    }

    function testMulWadUp() public {
        assertEq(MathMasters.mulWadUp(2.5e18, 0.5e18), 1.25e18);
        assertEq(MathMasters.mulWadUp(3e18, 1e18), 3e18);
        assertEq(MathMasters.mulWadUp(369, 271), 1);
    }

    function testMulWadUpFuzz(uint256 x, uint256 y) public {
        // We want to skip the case where x * y would overflow.
        // Since Solidity 0.8.0 checks for overflows by default,
        // we cannot just multiply x and y as this could revert.
        // Instead, we can ensure x or y is 0, or
        // that y is less than or equal to the maximum uint256 value divided by x
        if (x == 0 || y == 0 || y <= type(uint256).max / x) {
            uint256 result = MathMasters.mulWadUp(x, y);
            uint256 expected = x * y == 0 ? 0 : (x * y - 1) / 1e18 + 1;
            assertEq(result, expected);
        }
        // If the conditions for x and y are such that x * y would overflow,
        // this function will simply not perform the assertion.
        // In a testing context, you might want to handle this case differently,
        // depending on whether you want to consider such an overflow case as passing or failing.
    }

    function testSqrt() public {
        assertEq(MathMasters.sqrt(0), 0);
        assertEq(MathMasters.sqrt(1), 1);
        assertEq(MathMasters.sqrt(2704), 52);
        assertEq(MathMasters.sqrt(110889), 333);
        assertEq(MathMasters.sqrt(32239684), 5678);
        assertEq(MathMasters.sqrt(type(uint256).max), 340282366920938463463374607431768211455);
    }

    function testSqrtFuzzUni(uint256 x) public pure {
        assert(MathMasters.sqrt(x) == uniSqrt(x));
    }

    function testSqrtFuzzSolmate(uint256 x) public pure {
        assert(MathMasters.sqrt(x) == solmateSqrt(x));
    }

    function check_MulWad(uint256 x, uint256 y) public pure {
        // Ignore cases where x * y overflows.
        unchecked {
            if (x != 0 && (x * y) / x != y) return;
        }
        assert(MathMasters.mulWad(x, y) == (x * y) / 1e18);
    }

    function check_MulWadUp(uint256 x, uint256 y) public {
        if (x == 0 || y == 0 || y <= type(uint256).max / x) {
            uint256 result = MathMasters.mulWadUp(x, y);
            uint256 expected = x * y == 0 ? 0 : (x * y - 1) / 1e18 + 1;
            assertEq(result, expected);
        }
    }
    // Halmos FV test

    function check_sqrtCalculationBreaksOnMemory(uint256 x) public pure {
        (uint256 lowerBound, uint256 upperBound) = top1PercentRange();
        vm.assume(x >= lowerBound && x <= upperBound);
        // Calculate the square root using Solidity's built-in sqrt function as a reference
        uint256 expectedSqrt = sqrtReference(x);

        // Get the square root using the MathMasters library function
        uint256 actualSqrt = MathMasters.sqrt(x);

        // Define the maximum allowed deviation percentage (adjust as needed)
        uint256 maxDeviationPercentage = 1; // 1% maximum deviation

        // Calculate the maximum allowed deviation
        uint256 maxDeviation = (expectedSqrt * maxDeviationPercentage) / 100;

        // Ensure that the actual square root is within the allowed deviation range
        assert(actualSqrt >= expectedSqrt - maxDeviation && actualSqrt <= expectedSqrt + maxDeviation);
    }

    // Reference function to calculate square root using Solidity's built-in sqrt function
    function sqrtReference(uint256 x) internal pure returns (uint256) {
        uint256 z = x / 2 + 1;
        uint256 y = (z + x / z) / 2;
        while (y < z) {
            z = y;
            y = (z + x / z) / 2;
        }
        return z;
    }

    // Calculate the bounds for the top 1% of uint256 values
    function top1PercentRange() internal pure returns (uint256 lowerBound, uint256 upperBound) {
        uint256 maxUint256 = 2 ** 256 - 1;
        uint256 onePercentOfMax = maxUint256 / 100;

        // The upper bound is the maximum value
        upperBound = maxUint256;

        // The lower bound is 99% of the maximum value
        lowerBound = maxUint256 - onePercentOfMax;
    }
}
