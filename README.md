# 2024-Spring-HW2

Please complete the report problem below:

## Problem 1
Provide your profitable path, the amountIn, amountOut value for each swap, and your final reward (your tokenB balance).

> No path found.

## Problem 2
What is slippage in AMM, and how does Uniswap V2 address this issue? Please illustrate with a function as an example.

>   Slippage in the context of Automated Market Makers (AMMs) like Uniswap refers to the difference between the expected price of a trade and the price at which the trade is actually executed. This difference can occur due to the change in a trading pair's price caused by a trade itself, especially in pools with lower liquidity. 

>   AMMs like Uniswap allow trading of cryptocurrencies directly through liquidity pools without the need for traditional buyers and sellers to create a market. A typical AMM involves liquidity pools made up of pairs of different tokens. The price of tokens in these pools is determined by a mathematical formula rather than an order book used in traditional exchanges. The simplest form of this formula in Uniswap V1 and V2 is x⋅y=k, where x and y represent the quantity of two different tokens in the liquidity pool, and k is a constant. This formula aims to maintain a constant product of the quantities of the two tokens.

> To determine how much of token B, y, you will receive for a given amount of token A, Δx, you can use the invariant formula: 
y_final = k/(x_initial+Δx).
The amount of token B received, Δy, is then: 
Δy=y_initial - y_final
​

## Problem 3
Please examine the mint function in the UniswapV2Pair contract. Upon initial liquidity minting, a minimum liquidity is subtracted. What is the rationale behind this design?

在Uniswap V2中，首次增加流動性時會創建流動性代幣（LP tokens）。Uniswap V2會從首次鑄造的流動性代幣中扣除最少1000個代幣，這些代幣會被發送到零地址，實質上是被銷毀或永久鎖定。

這樣做的原因有幾個：

防止操縱： 確保第一個提供流動性的人不能通過將所有流動性撤出來操縱池子。
避免除法和四捨五入錯誤： 在極大或極小數量的加密貨幣操作中，保有一定量的非零起始餘額的LP代幣可以避免這些問題。
增強安全性： 初始銷毀的代幣確保了即使所有其他流動性被撤出，池中也始終存在一些流動性，從而增加了安全性。
確定LP代幣的價值： 這種方法設立了LP代幣的基礎價值，確保流動性池不會在一開始就被完全清空。
這個機制有效保障了流動性池的完整性，防止了潛在的操縱和計算錯誤。

## Problem 4
Investigate the minting function in the UniswapV2Pair contract. When depositing tokens (not for the first time), liquidity can only be obtained using a specific formula. What is the intention behind this?

在Uniswap V2中，當用戶向已存在的流動性池中存入代幣時，會根據一個特定的公式來計算新鑄造的流動性代幣（LP tokens）的數量。這個公式確保用戶獲得的LP代幣數量與其提供的流動性相對於池子現有規模的比例一致。

公式的目的：
比例擁有權：保證LP代幣的發行與用戶貢獻的流動性相比例，使得貢獻越多的用戶獲得更多的LP代幣。
激勵保持平衡：鼓勵用戶以接近市場價格的比率提供流動性，減少因偏離市場價格導致的潛在損失。
防止稀釋或過度鑄造：通過此公式確保不會不成比例地鑄造新代幣，保護現有流動性提供者的權益。
安全與穩定：這種基於數學的公式化方法使得流動性池的狀態與LP代幣的供應保持一致，增強了生態系統的安全性和可預測性。
去中心化與自主性：這個公式使Uniswap能夠在無需外部定價來源或主動管理的情況下運作，支持其去中心化的特性。

## Problem 5
What is a sandwich attack, and how might it impact you when initiating a swap?

三明治攻擊是一種在去中心化金融(DeFi)中常見的操縱市場行為，攻擊者會在目標用戶的交易前後各自發起一個交易。這種攻擊利用了區塊鏈交易確認的非即時性和公開性。

如何進行三明治攻擊：
偵測交易：攻擊者通過監視即將到來的交易池（mempool）來偵測用戶準備進行的交易。
前置交易：在用戶的交易被確認前，攻擊者快速發起一個提高特定資產價格的交易。
用戶交易：目標用戶的交易隨後被處理，由於前一交易已提高了價格，用戶將以更高的價格購買資產。
後置交易：攻擊者再發起一個賣出相同資產的交易，利用較高的價格賺取利潤。
影響：
成本增加：在三明治攻擊中，用戶將不得不以高於市場價格的成本來購買或賣出資產，因為攻擊者的前置交易已經人為推高了價格。
潛在損失：除了支付更高的交易費用，用戶可能還會因攻擊者的操縱而賣出資產的價格較低。

