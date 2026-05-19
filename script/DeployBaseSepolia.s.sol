// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../src/OwnableVault.sol";
import "../src/SignatureEscrow.sol";

interface Vm {
    function envUint(string calldata key) external view returns (uint256);
    function envOr(string calldata key, address defaultValue) external view returns (address);
    function startBroadcast(uint256 privateKey) external;
    function stopBroadcast() external;
}

contract DeployBaseSepolia {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run() external returns (OwnableVault vault, SignatureEscrow escrow) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.envOr("VAULT_OWNER", address(0));
        address signer = vm.envOr("ESCROW_SIGNER", address(0));

        vm.startBroadcast(deployerPrivateKey);

        address deployer = _senderFromPrivateKeyFallback();
        if (owner == address(0)) {
            owner = deployer;
        }
        if (signer == address(0)) {
            signer = deployer;
        }

        vault = new OwnableVault(owner);
        escrow = new SignatureEscrow(signer);

        vm.stopBroadcast();
    }

    function _senderFromPrivateKeyFallback() private view returns (address) {
        // Foundry sets msg.sender during broadcast simulation. This fallback keeps the script
        // simple for dry-runs; production deployment should set VAULT_OWNER and ESCROW_SIGNER.
        return msg.sender;
    }
}
