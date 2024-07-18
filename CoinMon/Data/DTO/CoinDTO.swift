struct CoinPriceResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass
    
    struct DataClass: Codable {
        let info: [CoinPriceInfoDTO]
    }
    
    static func toCoinPriceChangeGapList(dto: CoinPriceResponseDTO) -> [CoinPriceChangeGap] {
        return dto.data.info.compactMap { CoinPriceInfoDTO.toCoinPriceChangeGap(dto: $0) }
    }
    
    static func toCoinFeeList(dto: CoinPriceResponseDTO) -> [CoinFee] {
        return dto.data.info.compactMap { CoinPriceInfoDTO.toCoinFee(dto: $0) }
    }
    
    static func toCoinPriceListForPremium(dto: CoinPriceResponseDTO) -> [CoinPrice] {
        return dto.data.info.compactMap { CoinPriceInfoDTO.toCoinPriceForPremium(dto: $0) }
    }
    
    static func toCoinPriceListForSelectCoinsAtAlarm(dto: CoinPriceResponseDTO) -> [CoinPrice] {
        return dto.data.info.map { CoinPriceInfoDTO.toCoinPrice(dto: $0) }
    }
    
    static func toCoinPrice(dto: CoinPriceResponseDTO) -> CoinPrice {
        return dto.data.info.first.map { CoinPriceInfoDTO.toCoinPrice(dto: $0) } ?? CoinPrice(coinTitle: "AAA", price: "12345")
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
    
    static func toCoinPriceChangeGap(dto: CoinPriceInfoDTO) -> CoinPriceChangeGap? {
        var change = -99.0
        var gap = -99.0
        if let standardPrice = dto.standardPrice {
            if standardPrice != 0.0 || standardPrice != -100.0 {
                change = (dto.limitPrice - standardPrice) / standardPrice * 100
            }
        }
        if dto.marketPrice != 0.0 {
            gap = abs(dto.limitPrice - dto.marketPrice) / dto.marketPrice * 100
            
        }
        if dto.limitPrice == 0.0 {
            return nil
        }
        return CoinPriceChangeGap(
            coinTitle: dto.symbol,
            price: formatPrice(dto.limitPrice),
            change: String(format: "%.2f", change),
            gap: String(format: "%.2f", gap)
        )
    }
    
    static func toCoinFee(dto: CoinPriceInfoDTO) -> CoinFee? {
        if dto.fundingRate == 0.0 {
            return nil
        }
        if dto.limitPrice == 0.0 {
            return nil
        }
        return CoinFee(coinTitle: dto.symbol, fee: formatPrice(dto.fundingRate * 100), price: dto.limitPrice)
    }
    
    static func toCoinPriceForPremium(dto: CoinPriceInfoDTO) -> CoinPrice? {
        if dto.limitPrice == 0.0 {
            return nil
        }
        return CoinPrice(coinTitle: dto.symbol, price: formatPrice(dto.limitPrice))
    }
    
    static func toCoinPrice(dto: CoinPriceInfoDTO) -> CoinPrice {
        return CoinPrice(coinTitle: dto.symbol, price: formatPrice(dto.limitPrice))
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
