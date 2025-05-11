# Treasury Smart Contract

![Solidity Version](https://img.shields.io/badge/Solidity-^0.8.26-lightgrey?logo=solidity)
![License](https://img.shields.io/badge/License-MIT-blue)
![Upgradeable](https://img.shields.io/badge/Architecture-Upgradeable-success)

A secure, upgradeable treasury management contract for handling ETH and ERC20 tokens with WETH wrapping capabilities.

## Contract Address
**BASE**: [`0x777779DCA6fe0077C417aaab9a0723CD83A27777`](https://basescan.org/address/0x777779DCA6fe0077C417aaab9a0723CD83A27777)

## Features
- 💰 **Multi-Asset Management**: Handle both ETH and ERC20 tokens
- 🔄 **WETH Conversion**: Wrap/unwrap ETH to WETH
- 🔒 **Ownership Controls**: Restricted to contract owner
- ⬆️ **UUPS Upgradeable**: Contract can be upgraded
- 📊 **Balance Tracking**: View balances for all assets

## Functions

### Core Operations
| Function | Description | Access |
|----------|-------------|--------|
| `deposit(token, amount)` | Deposit ERC20 tokens | Public |
| `depositETH()` | Deposit ETH (payable) | Public |
| `withdraw(token, to, amount)` | Withdraw ERC20 tokens | Owner |
| `withdrawETH(to, amount)` | Withdraw ETH | Owner |

### WETH Operations
| Function | Description | Access |
|----------|-------------|--------|
| `wrapETH(amount)` | Convert ETH to WETH | Owner |
| `unwrapWETH(amount)` | Convert WETH back to ETH | Owner |

### View Functions
| Function | Returns |
|----------|---------|
| `getETHBalance()` | Treasury ETH balance |
| `getBalance(token)` | Balance of any ERC20 |
| `getWETHBalance()` | WETH balance |

## Events
```solidity
event Deposited(address indexed token, address indexed from, uint256 amount);
event DepositedETH(address indexed from, uint256 amount);
event Withdrawn(address indexed token, address indexed to, uint256 amount);
event WithdrawnETH(address indexed to, uint256 amount);
event WrappedETH(uint256 amount);
event UnwrappedWETH(uint256 amount);
```
