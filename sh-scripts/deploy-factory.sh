#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

forge create src/TokenLockFactory.sol:TokenLockFactory \
--rpc-url $MAINNET_RPC_URL \
--private-key $MAINNET_DEPLOYER_PK \
--legacy \
--broadcast
