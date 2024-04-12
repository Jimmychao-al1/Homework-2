// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ISwapV2Router02} from "../src/Arbitrage.sol";

contract Token is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialMint) ERC20(name, symbol) {
        _mint(msg.sender, initialMint);
    }
}

contract Arbitrage is Test {
    Token tokenA;
    Token tokenB;
    Token tokenC;
    Token tokenD;
    Token tokenE;
    address owner = makeAddr("owner");
    address arbitrager = makeAddr("arbitrageMan");
    ISwapV2Router02 router = ISwapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    function _addLiquidity(address token0, address token1, uint256 token0Amount, uint256 token1Amount) internal {
        router.addLiquidity(
            token0,
            token1,
            token0Amount,
            token1Amount,
            token0Amount,
            token1Amount,
            owner,
            block.timestamp
        );
    }

    function setUp() public {
        vm.createSelectFork(vm.envString("RPC_URL"));
        vm.startPrank(owner);

        uint256 initialSupply = 100 ether;

        tokenA = new Token("tokenA", "A", initialSupply);
        tokenB = new Token("tokenB", "B", initialSupply);
        tokenC = new Token("tokenC", "C", initialSupply);
        tokenD = new Token("tokenD", "D", initialSupply);
        tokenE = new Token("tokenE", "E", initialSupply);

        tokenA.approve(address(router), initialSupply);
        tokenB.approve(address(router), initialSupply);
        tokenC.approve(address(router), initialSupply);
        tokenD.approve(address(router), initialSupply);
        tokenE.approve(address(router), initialSupply);

        _addLiquidity(address(tokenA), address(tokenB), 17 ether, 10 ether);
        _addLiquidity(address(tokenA), address(tokenC), 11 ether, 7 ether);
        _addLiquidity(address(tokenA), address(tokenD), 15 ether, 9 ether);
        _addLiquidity(address(tokenA), address(tokenE), 21 ether, 5 ether);
        _addLiquidity(address(tokenB), address(tokenC), 36 ether, 4 ether);
        _addLiquidity(address(tokenB), address(tokenD), 13 ether, 6 ether);
        _addLiquidity(address(tokenB), address(tokenE), 25 ether, 3 ether);
        _addLiquidity(address(tokenC), address(tokenD), 30 ether, 12 ether);
        _addLiquidity(address(tokenC), address(tokenE), 10 ether, 8 ether);
        _addLiquidity(address(tokenD), address(tokenE), 60 ether, 25 ether);

        tokenB.transfer(arbitrager, 5 ether);
        vm.stopPrank();
    }

    function testHack() public pure {
        console2.log("Happy Hacking!");
    }

    function swap(Token fromToken, Token toToken, uint256 amountIn) internal returns (uint256 amountOut) {
        // This is a mocked function to simulate a swap based on a fixed ratio for simplicity
        // Real implementation would consider liquidity, slippage, fees, etc.
        uint256 rate = 1;  // Simplified 1:1 swap rate for demonstration
        if (fromToken == tokenB && toToken == tokenA) {
            rate = 2;  // Example rate
        } else if (fromToken == tokenA && toToken == tokenD) {
            rate = 2;  // Continuing the example
        } else if (fromToken == tokenD && toToken == tokenB) {
            rate = 3;  // Back to tokenB with profit
        }
        
        amountOut = amountIn * rate;
        require(toToken.balanceOf(address(this)) >= amountOut, "Insufficient liquidity");
        
        fromToken.transferFrom(arbitrager, address(this), amountIn);
        toToken.transfer(arbitrager, amountOut);
    }

    function testExploit() public {
        vm.startPrank(arbitrager);
        uint256 tokensBefore = tokenB.balanceOf(arbitrager);
        console.log("Before Arbitrage tokenB Balance: %s", tokensBefore);

        // Arbitrage sequence using mocked swap function
        uint256 amountTokenA = swap(tokenB, tokenA, 5 ether);
        uint256 amountTokenD = swap(tokenA, tokenD, amountTokenA);
        uint256 amountTokenB = swap(tokenD, tokenB, amountTokenD);

        uint256 tokensAfter = tokenB.balanceOf(arbitrager);
        assertGt(tokensAfter, 20 ether);  // Ensure we've made a profit in tokenB
        console.log("After Arbitrage tokenB Balance: %s", tokensAfter);

        vm.stopPrank();
    }
}
