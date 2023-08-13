// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.17;

import {WLYX} from "../src/WLYX.sol";

/// @dev Run the echidna fuzzing tests with
///      ```
///      solc-select use 0.8.17
///      echidna --config echidna.config.yaml --test-mode assertion echidna/TestWLYXAssertions.sol
///      ```
contract TestWLYXAssertions {

    WLYX wlyx;

    constructor() {
        wlyx = new WLYX();
    }

    function echidna_deposit_should_revert_with_amount_large_than_balance() public {
        uint256 amountToDeposit = address(this).balance + 1 wei;
        (bool success,) = address(wlyx).call(abi.encodeWithSelector(wlyx.deposit.selector, amountToDeposit));
        assert(!success);
    }

    function echidna_withdraw_should_revert_with_amount_larger_than_balance() public {
        uint256 amountToWithdraw = wlyx.balanceOf(address(this)) + 1 wei;
        (bool success,) = address(wlyx).call(abi.encodeWithSelector(wlyx.withdraw.selector, amountToWithdraw));
        assert(!success);
    }
    
}