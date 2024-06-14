struct CoinPriceResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: [CoinPriceInfoDTO]
    
    static func toPriceListsAtHome(dto: CoinPriceResponseDTO) -> [CoinPriceAtHome] {
            return dto.data.map { CoinPriceInfoDTO.toPriceListAtHome(dto: $0) }
        }
    
    static func toPriceListsAtAlarm(dto: CoinPriceResponseDTO) -> [CoinPriceAtAlarm] {
            return dto.data.map { CoinPriceInfoDTO.toPriceListAtAlarm(dto: $0) }
        }
}

struct CoinPriceInfoDTO: Codable {
    let id: Int
    let exchange: String
    let symbol: String
    let marketPrice: Double
    let limitPrice: Double
    let fundingRate: Double
    let standardPrice: Double
    let percent: Double
    let time: String
    
    static func toPriceListAtHome(dto: CoinPriceInfoDTO) -> CoinPriceAtHome {
           let change = abs((dto.limitPrice - dto.marketPrice) / dto.marketPrice) * 100
           let gap = abs(dto.limitPrice - dto.marketPrice) / dto.marketPrice * 100
           return CoinPriceAtHome(
               coinTitle: dto.symbol,
               price: formatPrice(dto.limitPrice),
               change: String(format: "%.2f%%", change),
               gap: String(format: "%.2f%%", gap)
           )
       }
    
    static func toPriceListAtAlarm(dto: CoinPriceInfoDTO) -> CoinPriceAtAlarm {
        return CoinPriceAtAlarm(coinTitle: dto.symbol, price: formatPrice(dto.limitPrice))
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
