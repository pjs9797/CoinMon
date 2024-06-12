struct Market: Equatable{
    let marketTitle: String
    let localizationKey: String
}

struct CoinPriceAtHome: Equatable{
    let coinTitle: String
    let price: String
    let change: String
    let gap: String
}

struct CoinFee: Equatable{
    let coinTitle: String
    let fee: String
}

struct CoinPremium: Equatable{
    let coinTitle: String
    let premium: String
}
