struct Market: Equatable{
    let marketTitle: String
    let localizationKey: String
}

struct PriceList: Equatable{
    let coinTitle: String
    let price: String
    let change: String
    let gap: String
}

struct FeeList: Equatable{
    let coinTitle: String
    let fee: String
}

struct PremiumList: Equatable{
    let coinTitle: String
    let premium: String
}
