// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library TokenLockLibrary {
    struct LockCreationParams {
        string title;
        address claimer;
        address token;
        uint256 lockAmount;
        uint256 releaseAmountAtTge;
        uint256 releaseAmountCycle;
        uint64 timeToTge;
        uint64 interval;
    }

    function _validateLock(
        TokenLockLibrary.LockCreationParams memory lock
    ) internal pure {
        require(lock.claimer != address(0), "Lock claimer must not be 0");
        require(lock.lockAmount > 0, "Lock amount must be positive");
        require(
            lock.timeToTge > 0,
            "TGE must be in the future"
        );
        require(lock.interval > 0, "Interval must be positive");
        require(
            lock.releaseAmountAtTge > 0 &&
                lock.releaseAmountAtTge <= lock.lockAmount,
            "Invalid release amount at Tge"
        );
        require(
            lock.releaseAmountCycle <= lock.lockAmount - lock.releaseAmountAtTge,
            "Invalid release cycle amount"
        );
    }
}
