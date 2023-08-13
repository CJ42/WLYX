// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.17;

import {WLYX} from "../src/WLYX.sol";

/// @dev Run the echidna fuzzing tests with
///      ```
///      solc-select use 0.8.17
///      echidna --config echidna.config.yaml echidna/TestWLYXProperties.sol
///      ```
contract TestWLYXProperties {

    WLYX wlyx;

    constructor() {
        wlyx = new WLYX();
    }

    // User balance must not exceed total supply
    function echidna_test_userBalanceLessThanTotalSupply() public payable returns (bool) {
        wlyx.deposit{ value: msg.value }();
        return wlyx.balanceOf(msg.sender) <= wlyx.totalSupply();
    }

    // Address zero should have zero balance
    function echidna_test_zeroaddressbalance() public payable returns (bool) {
        wlyx.deposit{ value: msg.value }();
        return wlyx.balanceOf(address(0)) == 0;
    }

    function echidna_test_withdraw_revert_with_amount_larger_than_balance() public returns (bool) {
        uint256 amountToWithdraw = wlyx.balanceOf(address(this)) + 1 wei;
        (bool success,) = address(wlyx).call(abi.encodeWithSelector(wlyx.withdraw.selector, amountToWithdraw));
        return (success == false);
    }
    
}