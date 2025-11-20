# Token Faucet

A simple faucet contract that allows a contract owner to deposit ETH and users to request a fixed amount of ETH with built-in rate-limiting to prevent abuse.

## Overview

Token Faucet implements a basic faucet mechanism for distributing ETH to users. The contract includes cooldown protection to prevent spam requests and provides the owner with administrative controls to manage the faucet parameters.

## Features

- **Fixed ETH Drip Amount**: Set a specific amount of ETH that users can request per transaction.
- **Cooldown Protection**: Built-in rate-limiting with configurable cooldown period (default: 1 day) to prevent abuse.
- **Owner-Only Administrative Controls**: Restrict critical functions to the contract owner:
  - Adjust drip amount
  - Modify cooldown duration
  - Withdraw faucet funds
- **Event Logging**: Event emissions for tracking deposits, requests, and transfers.
- **Balance Checking**: View the current faucet balance.
- **Public Deposits**: Anyone can deposit ETH to keep the faucet funded.

## Usage

### Deploying the Contract

When deploying, you must specify the drip amount (in wei) as a constructor parameter:

```solidity
// example: Set drip amount to 0.001 ETH (1000000000000000 wei)
constructor(1000000000000000)
```

### User Functions

#### Request Tokens

Users can request ETH from the faucet:

```solidity
requestTokens()
```

**Requirements:**
- Faucet must have sufficient balance
- User must wait for the cooldown period to expire between requests

#### Deposit Tokens

Anyone can deposit ETH to fund the faucet:

```solidity
depositTokens() payable
```

Send ETH with the transaction to add funds.

#### Check Faucet Balance

View the current faucet balance:

```solidity
faucetBalance() returns (uint256)
```

### Owner Functions

#### Set Faucet Limit

Change the amount of ETH distributed per request:

```solidity
setFaucetLimit(uint _amount)
```

**Parameter:** `_amount` - The new drip amount in wei

#### Set Request Cooldown

Modify the cooldown period between requests:

```solidity
setReqCooldown(uint256 _seconds)
```

**Parameter:** `_seconds` - Cooldown duration in seconds

#### Withdraw Faucet Tokens

Withdraw ETH from the faucet (owner only):

```solidity
withdrawFaucetTokens(uint _amount)
```

**Parameter:** `_amount` - Amount to withdraw in wei

## Events

The contract emits the following events:

- `UserDeposited(uint256 amount, string message)` - Triggered when ETH is deposited
- `TokensRequested(uint256 amount, string message)` - Triggered when a user requests tokens
- `TokensSent(address indexed user, string message)` - Triggered when tokens are sent to a user

## Security Considerations

- Only the contract owner can modify critical parameters.
- Built-in cooldown mechanism prevents rapid-fire requests.
- Balance checks ensure the faucet doesn't attempt to send more ETH than available.
- Users are tracked by address to enforce individual cooldown periods.

## Troubleshooting

### "Not enough tokens in faucet"

**Cause:** The faucet balance is insufficient to fulfill the request.

**Solution:** Deposit more ETH into the faucet using the `depositTokens()` function.

### "Req too soon"

**Cause:** The user is attempting to request tokens before the cooldown period has expired.

**Solution:** Wait for the cooldown period to complete. The default cooldown is 1 day. Check `reqCooldown` to see the current setting.

### "Not the contract owner"

**Cause:** You're attempting to call an owner-only function from a non-owner address.

**Solution:** Ensure you're calling the function from the address that deployed the contract.

### Transaction Fails with No Error Message

**Cause:** Insufficient gas or the transaction is reverting for an unexpected reason.

**Solution:** 
- Increase gas limit
- Check that you're sending ETH with `depositTokens()` calls
- Verify the faucet has sufficient balance before requesting tokens

### Potential Improvements

- Add multi-token support (ERC20)
- Implement dynamic drip amounts based on faucet balance
- Add whitelist/blacklist functionality
- Create a web interface for easier interaction
- Add comprehensive test suite

## License

This project is licensed under the [MIT](https://opensource.org/license/mit) License.

**Note:** This is a basic faucet implementation intended for educational and testing purposes. It was also built as a refresher project to revisit core Solidity and Web3 dev concepts.