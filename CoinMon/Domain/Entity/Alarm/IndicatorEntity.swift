struct IndicatorInfo: Equatable {
    let indicatorId: Int
    let indicatorName: String
    let indicatorDescription: String
    let isPremiumYN: String
    let isPushed: Bool
}

struct GetIndicatorData: Equatable {
    let indicatorId: Int
    let indicatorName: String
    let indicatorNameEng: String
    let indicatorDescription: String
    let indicatorDescriptionEng: String
    let moreDetail: String?
    let moreDetailEng: String?
    let isPremiumYN: String
    let frequency1YN: String
    let frequency5YN: String
    let frequency15YN: String
    let frequency30YN: String
    let frequency60YN: String
}

struct GetIndicatorPush: Equatable {
    let indicatorPushId: Int
    let indicatorId: Int
    let userName: String
    let frequency: String
    let target: Int
    let isOn: String
}

struct IndicatorCoinPriceChange: Equatable {
    let indicatorCoinId: String
    let coinTitle: String
    let price: String
    let change: String
    let gap: String
    var isChecked: Bool
}

struct SelectedIndicatorCoin: Equatable {
    let indicatorCoinId: String
    let coinTitle: String
}
