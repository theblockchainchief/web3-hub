// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/*
How to swap tokens

1. Alice has 100 tokens from AliceCoin, which is a ERC20 token.
2. Bob has 100 tokens from BobCoin, which is also a ERC20 token.
3. Alice and Bob wants to trade 10 AliceCoin for 20 BobCoin.
4. Alice or Bob deploys TokenSwap
5. Alice approves TokenSwap to withdraw 10 tokens from AliceCoin
6. Bob approves TokenSwap to withdraw 20 tokens from BobCoin
7. Alice or Bob calls TokenSwap.swap()
8. Alice and Bob traded tokens successfully.
*/

// Defining our own custom errors to save gas by not using the string literals.
error TokenSwap__TokenTransferFailed();
error TokenSwap__OnlyTokenOwnersCanSwap();
error TokenSwap__TokenAllowanceTooLow();

contract TokenSwap {
    IERC20 public token1;
    address public immutable i_owner1;
    uint256 public immutable i_amount1;
    IERC20 public token2;
    address public immutable i_owner2;
    uint256 public immutable i_amount2;

    // modifier to allow only the owners of tokens to execute functions.
    modifier onlyOwner() {
        if (!(msg.sender == i_owner1) && !(msg.sender == i_owner2)) {
            revert TokenSwap__OnlyTokenOwnersCanSwap();
        }

        _;
    }

    // Taking details of tokens to be swaped from deployer who is one of the token owners.
    constructor(
        address _token1,
        address _token2,
        address _owner1,
        address _owner2,
        uint256 _amount1,
        uint256 _amount2
    ) {
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
        i_owner1 = _owner1;
        i_owner2 = _owner2;
        i_amount1 = _amount1;
        i_amount2 = _amount2;
    }

    // Function to swap tokens
    function swap() public onlyOwner {
        // checking approval to withdraw tokens from each other
        if (token1.allowance(i_owner1, address(this)) < i_amount1) {
            revert TokenSwap__TokenAllowanceTooLow();
        }

        if (token1.allowance(i_owner2, address(this)) < i_amount2) {
            revert TokenSwap__TokenAllowanceTooLow();
        }

        // Finally transfering tokens
        _safeTransferFrom(token1, i_owner1, i_owner2, i_amount1);
        _safeTransferFrom(token2, i_owner2, i_owner1, i_amount2);
    }

    // Function to trasfer tokens
    function _safeTransferFrom(
        IERC20 token,
        address _from,
        address _to,
        uint256 _amount
    ) private {
        // Checking if the tokens successfully transfered, if not revert with the TokenSwap__TokenTransferFailed message
        bool success = token.transferFrom(_from, _to, _amount);
        if (!success) {
            revert TokenSwap__TokenTransferFailed();
        }
    }
}
