// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../src/SignatureEscrow.sol";

interface Vm {
    function addr(uint256 privateKey) external returns (address);
    function sign(uint256 privateKey, bytes32 digest) external returns (uint8 v, bytes32 r, bytes32 s);
    function warp(uint256 newTimestamp) external;
}

contract SignatureEscrowTest {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    uint256 private signerKey = 0xA11CE;
    address private recipient = address(0xB0B);

    function testClaimAcceptsValidSignatureAndIncrementsNonce() external {
        address signer = vm.addr(signerKey);
        SignatureEscrow escrow = new SignatureEscrow(signer);

        uint256 deadline = block.timestamp + 1 days;
        bytes memory signature = _sign(escrow, recipient, 100, 0, deadline);

        escrow.claim(recipient, 100, 0, deadline, signature);

        require(escrow.nonces(recipient) == 1, "nonce not incremented");
    }

    function testReplayFailsAfterNonceIncrement() external {
        address signer = vm.addr(signerKey);
        SignatureEscrow escrow = new SignatureEscrow(signer);

        uint256 deadline = block.timestamp + 1 days;
        bytes memory signature = _sign(escrow, recipient, 100, 0, deadline);

        escrow.claim(recipient, 100, 0, deadline, signature);

        (bool ok, ) = address(escrow).call(
            abi.encodeWithSelector(
                SignatureEscrow.claim.selector, recipient, 100, 0, deadline, signature
            )
        );

        require(!ok, "replay should fail");
    }

    function testExpiredSignatureFails() external {
        address signer = vm.addr(signerKey);
        SignatureEscrow escrow = new SignatureEscrow(signer);

        uint256 deadline = block.timestamp + 1 days;
        bytes memory signature = _sign(escrow, recipient, 100, 0, deadline);

        vm.warp(deadline + 1);

        (bool ok, ) = address(escrow).call(
            abi.encodeWithSelector(
                SignatureEscrow.claim.selector, recipient, 100, 0, deadline, signature
            )
        );

        require(!ok, "expired signature should fail");
    }

    function _sign(
        SignatureEscrow escrow,
        address claimRecipient,
        uint256 amount,
        uint256 nonce,
        uint256 deadline
    ) private returns (bytes memory) {
        bytes32 digest = escrow.claimDigest(claimRecipient, amount, nonce, deadline);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerKey, digest);
        return abi.encodePacked(r, s, v);
    }
}
