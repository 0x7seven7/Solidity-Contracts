// SPDX-License-Identifier: MIT
// BASE: 0x777779DCA6fe0077C417aaab9a0723CD83A27777

pragma solidity ^0.8.26;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/utils/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20PermitUpgradeable.sol";

contract Treasury is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    
    using SafeERC20Upgradeable for IERC20Upgradeable;
    address public WETH; // WETH contract address

    // Events
    event Deposited(address indexed token, address indexed from, uint256 amount);
    event DepositedETH(address indexed from, uint256 amount);
    event Withdrawn(address indexed token, address indexed to, uint256 amount);
    event WithdrawnETH(address indexed to, uint256 amount);
    event WrappedETH(uint256 amount);
    event UnwrappedWETH(uint256 amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner, address _weth) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
        WETH = _weth;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    // Receive ETH directly
    receive() external payable {
        emit DepositedETH(msg.sender, msg.value);
    }

    /**
     * @notice Deposit ERC20 tokens into the treasury
     * @param token Address of the token to deposit
     * @param amount Amount of tokens to deposit
     */
    function deposit(address token, uint256 amount) external {
        IERC20Upgradeable(token).safeTransferFrom(msg.sender, address(this), amount);
        emit Deposited(token, msg.sender, amount);
    }

    /**
     * @notice Deposit ETH into the treasury
     */
    function depositETH() external payable {
        emit DepositedETH(msg.sender, msg.value);
    }

    /**
     * @notice Withdraw ERC20 tokens from the treasury
     * @param token Address of the token to withdraw
     * @param to Address to send the tokens to
     * @param amount Amount of tokens to withdraw
     */
    function withdraw(address token, address to, uint256 amount) external onlyOwner {
        IERC20Upgradeable(token).safeTransfer(to, amount);
        emit Withdrawn(token, to, amount);
    }

    /**
     * @notice Withdraw ETH from the treasury
     * @param to Address to send ETH to
     * @param amount Amount of ETH to withdraw
     */
    function withdrawETH(address payable to, uint256 amount) external onlyOwner {
        (bool success, ) = to.call{value: amount}("");
        require(success, "ETH transfer failed");
        emit WithdrawnETH(to, amount);
    }

    /**
     * @notice Wrap ETH in the treasury into WETH
     * @param amount Amount of ETH to wrap
     */
    function wrapETH(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient ETH balance");
        (bool success, ) = WETH.call{value: amount}(
            abi.encodeWithSignature("deposit()")
        );
        require(success, "WETH wrapping failed");
        emit WrappedETH(amount);
    }

    /**
     * @notice Unwrap WETH in the treasury into ETH
     * @param amount Amount of WETH to unwrap
     */
    function unwrapWETH(uint256 amount) external onlyOwner {
        IERC20Upgradeable(WETH).safeTransfer(WETH, amount); // Send WETH to itself
        (bool success, ) = WETH.call(
            abi.encodeWithSignature("withdraw(uint256)", amount)
        );
        require(success, "WETH unwrapping failed");
        emit UnwrappedWETH(amount);
    }

    /**
     * @notice Get the ETH balance of the treasury
     * @return uint256 ETH balance
     */
    function getETHBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @notice Get the balance of a specific token in the treasury
     * @param token Address of the token
     * @return uint256 Balance of the token
     */
    function getBalance(address token) external view returns (uint256) {
        return IERC20Upgradeable(token).balanceOf(address(this));
    }

    /**
     * @notice Get the WETH balance of the treasury
     * @return uint256 WETH balance
     */
    function getWETHBalance() external view returns (uint256) {
        return IERC20Upgradeable(WETH).balanceOf(address(this));
    }
}
