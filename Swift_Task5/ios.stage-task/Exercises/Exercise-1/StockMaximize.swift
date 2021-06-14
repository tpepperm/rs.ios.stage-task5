import Foundation

class StockMaximize {

    func countProfit(prices: [Int]) -> Int {
        guard prices.count > 0 else { return 0 }

        var prices = prices
        var profit = 0
        while prices.count > 0 {
            profit += prices.max()! - prices[0]
            prices.remove(at: 0)
        }
        return profit
    }
}
