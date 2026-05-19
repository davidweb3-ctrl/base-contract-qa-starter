// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../src/OwnableVault.sol";

interface Vm {
    function deal(address who, uint256 newBalance) external;
    function prank(address msgSender) external;
}

contract OwnableVaultTest {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    address private owner = address(0xA11CE);
    address private user = address(0xB0B);

    function testDepositAcceptsEthWhenUnpaused() external {
        OwnableVault vault = new OwnableVault(owner);
        vm.deal(user, 1 ether);

        vm.prank(user);
        vault.deposit{ value: 0.25 ether }();

        require(address(vault).balance == 0.25 ether, "vault balance mismatch");
    }

    function testPausedDepositFails() external {
        OwnableVault vault = new OwnableVault(owner);
        vm.deal(user, 1 ether);

        vm.prank(owner);
        vault.setPaused(true);

        vm.prank(user);
        (bool ok, ) = address(vault).call{ value: 0.25 ether }(
            abi.encodeWithSelector(OwnableVault.deposit.selector)
        );

        require(!ok, "paused deposit should fail");
    }

    function testOnlyOwnerCanWithdraw() external {
        OwnableVault vault = new OwnableVault(owner);
        vm.deal(user, 1 ether);

        vm.prank(user);
        vault.deposit{ value: 0.5 ether }();

        vm.prank(user);
        (bool ok, ) = address(vault).call(
            abi.encodeWithSelector(OwnableVault.withdraw.selector, payable(user), 0.1 ether)
        );

        require(!ok, "non-owner withdraw should fail");
    }
}
