// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SignatureEscrow {
    error Expired();
    error InvalidNonce();
    error InvalidSignature();
    error ZeroRecipient();

    address public immutable signer;
    mapping(address => uint256) public nonces;

    event Claimed(address indexed recipient, uint256 amount, uint256 nonce);

    constructor(address authorizedSigner) {
        if (authorizedSigner == address(0)) revert InvalidSignature();
        signer = authorizedSigner;
    }

    function claim(
        address recipient,
        uint256 amount,
        uint256 nonce,
        uint256 deadline,
        bytes calldata signature
    ) external {
        if (recipient == address(0)) revert ZeroRecipient();
        if (block.timestamp > deadline) revert Expired();
        if (nonce != nonces[recipient]) revert InvalidNonce();

        bytes32 digest = claimDigest(recipient, amount, nonce, deadline);
        if (_recover(digest, signature) != signer) revert InvalidSignature();

        nonces[recipient] = nonce + 1;
        emit Claimed(recipient, amount, nonce);
    }

    function claimDigest(
        address recipient,
        uint256 amount,
        uint256 nonce,
        uint256 deadline
    ) public view returns (bytes32) {
        bytes32 inner = keccak256(
            abi.encode(block.chainid, address(this), recipient, amount, nonce, deadline)
        );
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", inner));
    }

    function _recover(bytes32 digest, bytes calldata signature) private pure returns (address) {
        if (signature.length != 65) revert InvalidSignature();

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := calldataload(signature.offset)
            s := calldataload(add(signature.offset, 32))
            v := byte(0, calldataload(add(signature.offset, 64)))
        }

        if (v < 27) v += 27;
        if (v != 27 && v != 28) revert InvalidSignature();

        address recovered = ecrecover(digest, v, r, s);
        if (recovered == address(0)) revert InvalidSignature();

        return recovered;
    }
}
