// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.17;

import {LSP7DigitalAsset} from "@lukso/lsp-smart-contracts/contracts/LSP7DigitalAsset/LSP7DigitalAsset.sol";

contract WLYX is LSP7DigitalAsset("Wrapped LYX", "WLYX", msg.sender, false) {
    event Deposit(address indexed dst, uint wad);
    event Withdrawal(address indexed src, uint wad);

    receive() external payable {
        deposit();
    }

    fallback() external payable {
        deposit();
    }

    function deposit() public payable {
        // TODO: add a check that the user has enough LYX? Or only in tests?
        // test if the custom error get triggered,
        // or if the function call fail before even getting into the function body

        emit Deposit(msg.sender, msg.value);
        _mint(msg.sender, msg.value, true, "Converted LYX to WLYX");
    }

    function withdraw(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "WLYX: cannot withdraw more than balance.");
        emit Withdrawal(msg.sender, amount);

        _burn(msg.sender, amount, "Converted WLYX to LYX");
        (bool success, ) = msg.sender.call{value: amount}("");

        require(success, "WLYX: withdraw failed.");
    }
}
