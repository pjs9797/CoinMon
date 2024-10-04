struct PriceChange: Equatable {
    let title: String
    var priceChange: Double
}

struct DetailBasicInfo: Equatable {
    let favoritesId: Int?
    let isPush: Bool
    let isFavorites: Bool
    let lastPrice1: String
}

struct DetailPriceInfo {
    let lowHighPrice: LowHighPrice
    let historicalPrices: HistoricalPrices
}

struct LowHighPrice {
    let low: String
    let high: String
}

struct HistoricalPrices {
    let lastPrice1: String
    let lastPrice7: String
    let lastPrice30: String
    let lastPrice90: String
    let lastPrice365: String
}
