# NFTStaking Smart Contract - Read Me

## Table of Contents

1. [Introduction](#introduction)
2. [Smart Contract Overview](#smart-contract-overview)
    - [Token Interface](#token-interface)
    - [Data Structures](#data-structures)
    - [Constructor](#constructor)
3. [Token Management](#token-management)
    - [totalSupply](#totalsupply)
    - [balanceOf](#balanceof)
    - [approve](#approve)
    - [transferFrom](#transferfrom)
4. [NFT Staking](#nft-staking)
    - [BuyNFT](#buynft)
    - [Check_Claim_Amount](#check_claim_amount)
    - [claim](#claim)
5. [Voting System](#voting-system)
    - [createVote](#createvote)
    - [setFinishVote](#setfinishvote)
    - [vote](#vote)
    - [getCustomerRecord](#getcustomerrecord)
    - [getVoteRecord](#getvoterecord)
6. [Owner Functions](#owner-functions)
    - [Owner](#owner)
7. [Security Considerations](#security-considerations)
8. [Conclusion](#conclusion)

## 1. Introduction

Welcome to the documentation for the **NFTStaking** smart contract. This document provides a detailed explanation of the functionalities and usage of the contract, which is designed to facilitate NFT staking, token management, and a voting system.

## 2. Smart Contract Overview

### Token Interface

The contract interacts with an ERC-20 token through the `IERC20` interface. This allows for transferring tokens and managing allowances.

### Data Structures

- `balances`: A mapping of addresses to token balances.
- `allowance`: A mapping of addresses to authorized token spending.
- `mintingTokens`: A mapping of addresses to tokens being minted from staking.
- `lastUpdateTime`: A mapping of addresses to the timestamp of their last update.

### Constructor

The constructor initializes the smart contract and sets the `usdtToken` address, representing the ERC-20 token used for staking and rewards.

## 3. Token Management

### totalSupply

Returns the total supply of the staking token.

### balanceOf

Returns the balance of a specified address.

### approve

Allows a spender to spend tokens on behalf of the owner, up to a specified value.

### transferFrom

Transfers tokens from the sender to a recipient, provided the sender is authorized by the owner.

## 4. NFT Staking

### BuyNFT

Allows users to stake tokens for NFTs, updating balances and records accordingly.

### Check_Claim_Amount

Calculates the amount that a user can claim as rewards for their staked tokens.

### claim

Allows users to claim rewards for their staked tokens, updating balances, minted tokens, and timestamps.

## 5. Voting System

### createVote

Owner-only function to create a new voting topic with specified start and end dates.

### setFinishVote

Owner-only function to set the voting status to finished for a specific topic.

### vote

Allows users to vote on a topic, updating voting records and customer information.

### getCustomerRecord

Allows users to view their voting-related records for a specific topic.

### getVoteRecord

Allows users to view voting records for a specific topic.

## 6. Owner Functions

### Owner

Internal function returning the contract owner's address.

## 7. Security Considerations

The smart contract aims to implement security measures, including:

- Ownership controls for critical functions.
- Token transfer checks to ensure sufficient balances and allowances.
- Periodic claim and time-based restrictions to prevent abuse.

However, users should exercise caution and perform due diligence before interacting with the contract.

## 8. Conclusion

The **NFTStaking** smart contract provides a comprehensive solution for NFT staking, token management, and a secure voting system. Users can stake tokens, claim rewards, and participate in voting, while the owner has control over key functions. Please review the documentation carefully before using the smart contract to ensure a safe and effective experience.
