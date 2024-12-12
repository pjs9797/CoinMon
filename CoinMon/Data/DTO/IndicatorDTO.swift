struct IndicatorDTO: Codable {
    let resultCode: String
    let resultMessage: String
    
    static func toResultCode(dto: IndicatorDTO) -> String {
        let resultCode = dto.resultCode
        return resultCode
    }
}


struct GetIndicatorResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: [GetIndicatorDataDTO]
    }
    
    static func toGetIndicatorDatas(dto: GetIndicatorResponseDTO) -> [GetIndicatorData] {
        return dto.data.info.map {
            GetIndicatorData(indicatorId: $0.indicatorId, indicatorName: $0.indicatorName, indicatorNameEng: $0.indicatorNameEng, indicatorDescription: $0.indicatorDescription, indicatorDescriptionEng: $0.indicatorDescriptionEng, moreDetail: $0.moreDetail, moreDetailEng: $0.moreDetailEng, isPremiumYN: $0.isPremiumYN, frequency1YN: $0.frequency1YN, frequency5YN: $0.frequency5YN, frequency15YN: $0.frequency15YN, frequency30YN: $0.frequency30YN, frequency60YN: $0.frequency60YN)
        }
    }
}

struct GetIndicatorDataDTO: Codable {
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

struct GetIndicatorCoinDataResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: [IndicatorCoinDataDTO]
    }
    
    static func toIndicatorCoinData(dto: GetIndicatorCoinDataResponseDTO) -> [IndicatorCoinData] {
        return dto.data.info
            .filter { !$0.coinName.isEmpty }
            .map {
            IndicatorCoinData(indicatorId: $0.indicatorId, indicatorCoinId: String($0.indicatorCoinId), indicatorName: $0.indicatorName, indicatorNameEng: $0.indicatorNameEng, isPremium: $0.isPremium, frequency: $0.frequency, coinName: $0.coinName, isOn: $0.isOn, curPrice: $0.curPrice, recentTime: $0.recentTime, recentPrice: $0.recentPrice, timing: $0.timing)
        }.sorted{ $0.indicatorId < $1.indicatorId }
    }
}

struct IndicatorCoinDataDTO: Codable {
    let indicatorPushId: Int
    let indicatorId: Int
    let indicatorCoinId: Int
    let indicatorName: String
    let indicatorNameEng: String
    let isPremium: String
    let frequency: String
    let coinName: String
    let isOn: String
    let curPrice: Double
    let recentTime: String?
    let recentPrice: Double?
    let timing: String?
}

struct GetIndicatorCoinDetailDataResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: [IndicatorCoinDetailDataDTO]
    }
    
    static func toUpdateIndicatorCoinData(dto: GetIndicatorCoinDetailDataResponseDTO) -> [UpdateSelectedIndicatorCoin] {
        return dto.data.info.enumerated().map { index, data in
            UpdateSelectedIndicatorCoin(indicatorCoinId: data.indicatorCoinId, coinTitle: data.coinName, isPinned: index == 0, isChecked: false)
        }
    }
}

struct IndicatorCoinDetailDataDTO: Codable {
    let indicatorPushId: Int
    let indicatorId: Int
    let indicatorCoinId: Int
    let indicatorName: String
    let indicatorNameEng: String
    let isPremium: String
    let frequency: String
    let coinName: String
    let isOn: String
    let curPrice: Double
    let recentTime: String?
    let recentPrice: Double?
    let timing: String?
}

struct GetIndicatorCoinListResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: [GetIndicatorCoinListDTO]
    }
    
    static func toIndicatorCoinPriceChanges(dto: GetIndicatorCoinListResponseDTO) -> [IndicatorCoinPriceChange] {
        return dto.data.info.compactMap { coinListDTO in
            let priceString = formatPrice(coinListDTO.limitPrice)
            let changeString = String(format: "%.2f", coinListDTO.percent)
            
            return IndicatorCoinPriceChange(
                indicatorCoinId: String(coinListDTO.indicatorCoinId),
                coinTitle: coinListDTO.coinName,
                price: priceString,
                change: changeString, 
                isPinned: false,
                isChecked: false
            )
        }
    }
    
    static func formatPrice(_ price: Double) -> String {
        var priceString = String(format: "%.8f", price)
        
        while priceString.last == "0" {
            priceString.removeLast()
        }
        
        if priceString.last == "." {
            priceString.removeLast()
        }
        
        if priceString.count > 9 {
            priceString = String(priceString.prefix(9))
            
            if priceString.last == "." {
                priceString.removeLast()
            }
        }
        
        return priceString
    }
}

struct GetIndicatorCoinListDTO: Codable {
    let indicatorCoinId: Int
    let indicatorId: Int
    let coinName: String
    let marketPrice: Double
    let limitPrice: Double
    let standardPrice: Double
    let percent: Double
}

struct GetIndicatorCoinHistoryResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: [GetIndicatorCoinHistoryDTO]
    }
    
    static func toIndicatorCoinHistory(dto: GetIndicatorCoinHistoryResponseDTO) -> [IndicatorCoinHistory] {
        return dto.data.info.map {
            IndicatorCoinHistory(price: String($0.price), timing: $0.timing, time: $0.time)
        }
    }
}

struct GetIndicatorCoinHistoryDTO: Codable {
    let indicatorCoinHistoryId: Int
    let indicatorId: Int
    let indicatorCoinId: Int
    let price: Double
    let timing: String
    let time: String
}
