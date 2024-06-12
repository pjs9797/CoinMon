struct AlarmList {
    let coinTitle: String
    let setPrice: Double
    let currentPrice: Double
    let isOn: Bool
}

struct CoinPriceAtAlarm: Equatable{
    let coinTitle: String
    let price: String
}
