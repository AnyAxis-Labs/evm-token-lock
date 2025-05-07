// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address, uint256) external returns(bool);
    function transferFrom(address, address, uint256) external returns (bool);
    function approve(address, uint256) external;
}