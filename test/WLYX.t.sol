// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import {WLYX} from "../src/WLYX.sol";

import {
    _LSP4_SUPPORTED_STANDARDS_KEY,
    _LSP4_SUPPORTED_STANDARDS_VALUE,
    _LSP4_TOKEN_NAME_KEY,
    _LSP4_TOKEN_SYMBOL_KEY
} from "@lukso/lsp-smart-contracts/contracts/LSP4DigitalAssetMetadata/LSP4Constants.sol";

contract WLYXTest is Test {

    WLYX wlyx;

    // used to test withdrawing WLYX and get LYX back
    receive() external payable {
        return;
    }

    function setUp() public {
        wlyx = new WLYX();
    }

    function test_decimals() public {
        assertEq(wlyx.decimals(), 18);
    }

    function test_constructor() public {
        // CHECK contract owner is this contract that deployed it;
        assertEq(wlyx.owner(), address(this));

        // CHECK Metadata was set correctly in ERC725Y storage
        assertEq(wlyx.getData(_LSP4_SUPPORTED_STANDARDS_KEY), _LSP4_SUPPORTED_STANDARDS_VALUE);
        assertEq(wlyx.getData(_LSP4_TOKEN_NAME_KEY), bytes("Wrapped LYX"));
        assertEq(wlyx.getData(_LSP4_TOKEN_SYMBOL_KEY), bytes("WLYX"));
    }


    function test_deposit() public {
        uint256 depositAmount = 10 ether;

        uint256 initialLyxBalance = address(this).balance;
        uint256 initialWrappedLyxBalance = wlyx.balanceOf(address(this));
        assertEq(initialWrappedLyxBalance, 0);

        wlyx.deposit{ value: depositAmount }();

        uint256 newLyxBalance = address(this).balance;
        uint256 newWrappedLyxBalance = wlyx.balanceOf(address(this));

        assertEq(newLyxBalance, initialLyxBalance - depositAmount);
        assertEq(newWrappedLyxBalance, 10 ether);
    }

    function testFail_depositMoreThanLYXBalance(uint256 extraAmount) public {
        assert(extraAmount != 0);
        uint256 depositAmount = address(this).balance + extraAmount;
        wlyx.deposit{ value: depositAmount }();
    }

    function test_withdrawEverything() public {
        uint256 depositAmount = 10 ether;
        wlyx.deposit{ value: depositAmount }();

        uint256 lyxBalanceBeforeWithdraw = address(this).balance;
        uint256 wrappedLyxBalanceBeforeWithdraw = wlyx.balanceOf(address(this));
        assertEq(wrappedLyxBalanceBeforeWithdraw, depositAmount);

        // withdraw everything deposited
        wlyx.withdraw(wrappedLyxBalanceBeforeWithdraw);

        uint256 lyxBalanceAfterWithdraw = address(this).balance;
        assertEq(lyxBalanceAfterWithdraw, lyxBalanceBeforeWithdraw + wrappedLyxBalanceBeforeWithdraw);

        uint256 wrappedLyxBalanceAfterWithdraw = wlyx.balanceOf(address(this));
        assertEq(wrappedLyxBalanceAfterWithdraw, 0);
    }


}