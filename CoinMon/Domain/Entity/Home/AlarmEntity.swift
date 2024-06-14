struct Alarm: Equatable {
    let alarmId: Int
    let market: String
    let coinTitle: String
    let setPrice: String
    let filter: String
    let cycle: String
    let isOn: Bool
}

struct CoinPriceAtAlarm: Equatable{
    let coinTitle: String
    let price: String
}
