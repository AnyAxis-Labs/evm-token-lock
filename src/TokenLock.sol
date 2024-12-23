// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/math/Math.sol";

import "./libs/TokenLock.sol";
import "./Math/SafeMath.sol";

import "./interfaces/IERC20.sol";

contract TokenLock {
    using Math for uint256;

    struct LockInfo {
        string title;
        address claimer;
        address token;
        uint256 lockAmount;
        uint256 releaseAmountAtTge;
        uint256 releaseAmountCycle;
        uint256 claimedAmount;
        uint64 tge;
        uint64 interval;
    }

    event Claim(address, uint256);

    LockInfo public lockInfo;

    constructor(TokenLockLibrary.LockCreationParams memory lock) {
        _createLock(lock);
    }

    function claim() external {
      uint256 claimable = getClaimable();
        require(
            claimable > 0,
            "Claimable amount is zero"
        );
        lockInfo.claimedAmount = lockInfo.claimedAmount + claimable;
        require(IERC20(lockInfo.token).transfer(
            lockInfo.claimer,
            claimable
        ), "Failed to transfer token to claimer");
        emit Claim(lockInfo.claimer, claimable);
    }

    function _createLock(
        TokenLockLibrary.LockCreationParams memory lock
    ) internal {
        TokenLockLibrary._validateLock(lock);
        // Initialize lockInfo with the values from lock
        lockInfo = LockInfo({
            title: lock.title,
            claimer: lock.claimer,
            token: lock.token,
            lockAmount: lock.lockAmount,
            claimedAmount: 0,
            tge: lock.timeToTge + uint64(block.timestamp),
            interval: lock.interval,
            releaseAmountCycle: lock.releaseAmountCycle,
            releaseAmountAtTge: lock.releaseAmountAtTge
        });
    }

    function getClaimable() public view returns (uint256) {
        uint64 currentTs = uint64(block.timestamp);
        if (lockInfo.tge > currentTs) return 0;
        uint256 intervalCount = (currentTs - lockInfo.tge) / lockInfo.interval;
        uint256 leftAmount = lockInfo.lockAmount - lockInfo.claimedAmount;
        uint256 maxClaimable = lockInfo.releaseAmountAtTge + intervalCount * lockInfo.releaseAmountCycle - lockInfo.claimedAmount;
        return Math.min(maxClaimable, leftAmount);
    }
}
