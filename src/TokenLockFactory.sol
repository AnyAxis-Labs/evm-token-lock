// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./libs/TokenLock.sol";
import "./TokenLock.sol";
import "./interfaces/IERC20.sol";

contract TokenLockFactory {
    event CreateLock(address);
    function createTokenLock(
        TokenLockLibrary.LockCreationParams memory lock
    ) external {
        TokenLock lockContract = new TokenLock(lock);

        require(IERC20(lock.token).transferFrom(
            msg.sender,
            address(lockContract),
            lock.lockAmount
        ), "Failed to transfer lock amount");
        emit CreateLock(address(lockContract));
    }
}
