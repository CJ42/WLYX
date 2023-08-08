// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.17;

import {WLYX} from "../src/WLYX.sol";

/// @dev Run the echidna fuzzing tests with
///      ```
///      solc-select use 0.8.17
///      echidna --config echidna.yaml echidna/TestWLYX.sol
///      ```
contract TestWLYX is WLYX {
    function echidna_test_deposit() public payable {
        uint256 oldBalance = balanceOf(msg.sender);

        this.deposit{ value: 10 ether }();

        assert(balanceOf(msg.sender) == 10 ether);
    }
}