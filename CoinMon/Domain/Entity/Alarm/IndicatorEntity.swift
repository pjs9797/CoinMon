struct IndicatorCoinData: Equatable {
    let indicatorId: Int
    let indicatorCoinId: String
    let indicatorName: String
    let indicatorNameEng: String
    let isPremium: String
    let frequency: String
    let coinName: String
    var isOn: String
    let curPrice: Double
    let recentTime: String?
    let recentPrice: Double?
    let timing: String?
}

struct UpdateIndicatorCoinData: Equatable {
    let indicatorId: Int
    let indicatorName: String
    let indicatorNameEng: String
    let isPremium: String
    let frequency: String
    let coinName: String
    var isOn: String
    let curPrice: Double
    let recentTime: String?
    let recentPrice: Double?
    let timing: String?
    var isPinned: Bool
}

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

struct IndicatorCoinPriceChange: Equatable {
    let indicatorCoinId: String
    let coinTitle: String
    let price: String
    let change: String
    var isPinned: Bool
    var isChecked: Bool
}

struct SelectedIndicatorCoin: Equatable {
    let indicatorCoinId: String
    let coinTitle: String
}

struct UpdateSelectedIndicatorCoin: Equatable {
    let indicatorCoinId: Int
    let coinTitle: String
    var isPinned: Bool
    var isChecked: Bool
}

struct IndicatorCoinHistory: Equatable {
    let price: String
    let timing: String
    let time: String
}
