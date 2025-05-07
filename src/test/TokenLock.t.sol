// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../interfaces/IERC20.sol";

import "../TokenLockFactory.sol";

contract TokenLockTest is Test {
    IERC20 token;
    TokenLockFactory factory;
    address user = 0xEB5491C015b73C3B86F4B4a7E8982d97eC4628ff;
    function setUp() public {
        uint256 fork = vm.createFork("https://andromeda.metis.io/?owner=1088");
        vm.selectFork(fork);
        token = IERC20(0xECD0E10503B2CD39AaE275d30063Ba5CD7c05238);
        factory = TokenLockFactory(0x5200524C0314E8583F729c42040Ec0E13A3534b5);
    }

    function testCreateLock() public {
        vm.startBroadcast(user);
        token.approve(address(factory), 200000 ether);
        TokenLockLibrary.LockCreationParams memory lock = TokenLockLibrary
            .LockCreationParams({
                title: "ABC",
                claimer: user,
                token: address(token),
                lockAmount: 200000 ether,
                releaseAmountAtTge: 50000 ether,
                releaseAmountCycle: 1000 ether,
                timeToTge: 10000,
                interval: 3600
            });

        factory.createTokenLock(lock);
        vm.stopBroadcast();
    }
}
