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

struct GetIndicatorPushResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: [GetIndicatorPushDTO]
    }
    
    static func toGetIndicatorPushs(dto: GetIndicatorPushResponseDTO) -> [GetIndicatorPush] {
        return dto.data.info.map {
            GetIndicatorPush(indicatorPushId: $0.indicatorPushId, indicatorId: $0.indicatorId, userName: $0.userName, frequency: $0.frequency, target: $0.target, isOn: $0.isOn)
        }
    }
}

struct GetIndicatorPushDTO: Codable {
    let indicatorPushId: Int
    let indicatorId: Int
    let userName: String
    let frequency: String
    let target: Int
    let isOn: String
}

struct GetIndicatorCoinListResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: [GetIndicatorCoinListDTO]
        
        init(from decoder: Decoder) throws {
            var container = try decoder.container(keyedBy: CodingKeys.self)
            var infoArray = try container.nestedUnkeyedContainer(forKey: .info)
            var parsedInfo = [GetIndicatorCoinListDTO]()
            
            while !infoArray.isAtEnd {
                var nestedContainer = try infoArray.nestedUnkeyedContainer()
                let indicatorCoinDTO = try nestedContainer.decode(IndicatorCoinDTO.self)
                let coinPriceInfoDTO = try nestedContainer.decode(CoinPriceInfoDTO.self)
                
                let dto = GetIndicatorCoinListDTO(indicatorCoinDTO: indicatorCoinDTO, coinPriceInfoDTO: coinPriceInfoDTO)
                parsedInfo.append(dto)
            }
            
            self.info = parsedInfo
        }
    }
    
    static func toIndicatorCoinPriceChanges(dto: GetIndicatorCoinListResponseDTO) -> [IndicatorCoinPriceChange] {
        return dto.data.info.compactMap { coinListDTO in
            let coinPriceChangeGap = CoinPriceInfoDTO.toCoinPriceChangeGap(dto: coinListDTO.coinPriceInfoDTO)
            guard let priceChangeGap = coinPriceChangeGap else {
                return nil
            }
            return IndicatorCoinPriceChange(
                indicatorCoinId: String(coinListDTO.indicatorCoinDTO.indicatorCoinId),
                coinTitle: priceChangeGap.coinTitle,
                price: priceChangeGap.price,
                change: priceChangeGap.change,
                gap: priceChangeGap.gap,
                isChecked: false
            )
        }
    }
}

struct GetIndicatorCoinListDTO: Codable {
    let indicatorCoinDTO: IndicatorCoinDTO
    let coinPriceInfoDTO: CoinPriceInfoDTO
}

struct IndicatorCoinDTO: Codable {
    let indicatorCoinId: Int
    let indicatorId: Int
    let coinName: String
}
