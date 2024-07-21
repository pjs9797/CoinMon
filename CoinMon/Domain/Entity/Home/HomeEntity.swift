struct Market: Equatable{
    let marketTitle: String
    let localizationKey: String
}

struct CoinPriceChangeGap: Equatable{
    let coinTitle: String
    let price: String
    let change: String
    let gap: String
}

struct CoinFee: Equatable{
    let coinTitle: String
    let fee: String
    let price: Double
}

struct CoinPremium: Equatable{
    let coinTitle: String
    let premium: String
    let price: Double
}

struct CoinPrice: Equatable{
    let coinTitle: String
    let price: String
}

enum SortOrder {
    case none
    case ascending
    case descending
}

struct NotificationAlert: Equatable{
    let id: Int
    let market: String
    let symbol: String
    let targetPrice: String
    let date: String
    let dateType: String
}
