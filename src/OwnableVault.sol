// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract OwnableVault {
    error NotOwner();
    error Paused();
    error WithdrawFailed();
    error ZeroAmount();

    address public immutable owner;
    bool public paused;

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed recipient, uint256 amount);
    event PauseChanged(bool paused);

    constructor(address initialOwner) {
        if (initialOwner == address(0)) revert NotOwner();
        owner = initialOwner;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier whenNotPaused() {
        if (paused) revert Paused();
        _;
    }

    function setPaused(bool nextPaused) external onlyOwner {
        paused = nextPaused;
        emit PauseChanged(nextPaused);
    }

    function deposit() external payable whenNotPaused {
        if (msg.value == 0) revert ZeroAmount();
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(address payable recipient, uint256 amount) external onlyOwner {
        if (amount == 0) revert ZeroAmount();

        (bool ok, ) = recipient.call{ value: amount }("");
        if (!ok) revert WithdrawFailed();

        emit Withdrawn(recipient, amount);
    }
}
