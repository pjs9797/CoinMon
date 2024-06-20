struct CoinPriceResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: [CoinPriceInfoDTO]
    }
    
    static func toPriceListsAtHome(dto: CoinPriceResponseDTO) -> [CoinPrice] {
        return dto.data.info.compactMap { CoinPriceInfoDTO.toPriceListAtHome(dto: $0) }
    }
    
    static func toPremiumLists(dto: CoinPriceResponseDTO) -> [OneCoinPrice] {
        return dto.data.info.compactMap { CoinPriceInfoDTO.toPremiumList(dto: $0) }
    }
    
    static func toPriceListsAtAlarm(dto: CoinPriceResponseDTO) -> [OneCoinPrice] {
        return dto.data.info.map { CoinPriceInfoDTO.toPriceListAtAlarm(dto: $0) }
    }
    
    static func toOnePriceListsAtAlarm(dto: CoinPriceResponseDTO) -> OneCoinPrice {
        return dto.data.info.first.map { CoinPriceInfoDTO.toPriceListAtAlarm(dto: $0) } ?? OneCoinPrice(coinTitle: "AAA", price: "12345")
    }
    
    static func toFeeList(dto: CoinPriceResponseDTO) -> [CoinFee] {
        return dto.data.info.compactMap { CoinPriceInfoDTO.toFeeList(dto: $0) }
    }
}

struct CoinPriceInfoDTO: Codable {
    let id: Int
    let exchange: String
    let symbol: String
    let marketPrice: Double
    let limitPrice: Double
    let fundingRate: Double
    let standardPrice: Double?
    let percent: Double
    let time: String
    
    static func toPriceListAtHome(dto: CoinPriceInfoDTO) -> CoinPrice? {
        var change = -99.0
        var gap = -99.0
        if let standardPrice = dto.standardPrice {
            if standardPrice != 0.0 || standardPrice != -100.0 {
                change = (standardPrice - dto.limitPrice) / standardPrice * 100
            }
        }
        if dto.marketPrice != 0.0 {
            gap = abs(dto.limitPrice - dto.marketPrice) / dto.marketPrice * 100
            
        }
        if dto.limitPrice == 0.0 {
            return nil
        }
        return CoinPrice(
            coinTitle: dto.symbol,
            price: formatPrice(dto.limitPrice),
            change: String(format: "%.2f", change),
            gap: String(format: "%.2f", gap)
        )
    }
    
    static func toPremiumList(dto: CoinPriceInfoDTO) -> OneCoinPrice? {
        if dto.limitPrice == 0.0 {
            return nil
        }
        return OneCoinPrice(coinTitle: dto.symbol, price: formatPrice(dto.limitPrice))
    }
    
    static func toPriceListAtAlarm(dto: CoinPriceInfoDTO) -> OneCoinPrice {
        return OneCoinPrice(coinTitle: dto.symbol, price: formatPrice(dto.limitPrice))
    }
    
    static func toFeeList(dto: CoinPriceInfoDTO) -> CoinFee? {
        if dto.fundingRate == 0.0 {
            return nil
        }
        return CoinFee(coinTitle: dto.symbol, fee: formatPrice(dto.fundingRate * 100))
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
