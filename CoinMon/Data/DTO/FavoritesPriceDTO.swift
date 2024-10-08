import Foundation

struct FavoritesPriceResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass?
    
    struct DataClass: Codable {
        let info: [FavoritesPriceDTO]
    }
    
    static func toCoinPriceChangeGapsSorted(dto: FavoritesPriceResponseDTO) -> [CoinPriceChangeGap] {
        guard let info = dto.data?.info else {
            return []
        }
        
        let sortedInfo = info.sorted { $0.favoritesOrder < $1.favoritesOrder }
        
        return sortedInfo.compactMap { FavoritesPriceDTO.toCoinPriceChangeGap(dto: $0) }
    }
    
    static func toFavorites(dto: FavoritesPriceResponseDTO) -> [Favorites] {
        return dto.data?.info.map { FavoritesPriceDTO.toFavorites(dto: $0) } ?? []
    }
}

struct FavoritesResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass?
    
    struct DataClass: Codable {
        let info: [FavoritesDTO]
    }
    
    static func toResultCode(dto: FavoritesResponseDTO) -> String {
        return dto.resultCode
    }
}

struct FavoritesDTO: Codable {
    let id: Int
    let user: String
    let symbol: String
    let market: String
    let favoritesOrder: Int
    let registerTime: [Int]
}

struct FavoritesPriceDTO: Codable {
    let id: Int
    let user: String
    let symbol: String
    let market: String
    let favoritesOrder: Int
    let marketPrice: Double
    let limitPrice: Double
    let fundingRate: Double
    let standardPrice: Double?
    let percent: Double
    
    static func toFavorites(dto: FavoritesPriceDTO) -> Favorites {
        return Favorites(id: String(dto.id), symbol: dto.symbol, favoritesOrder: dto.favoritesOrder)
    }
    
    static func toCoinPriceChangeGap(dto: FavoritesPriceDTO) -> CoinPriceChangeGap? {
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

struct FavoritesUpdateOrderDTO: Codable{
    let symbol: String
    let favoritesOrder: Int
    
    static func toFavoritesUpdateOrderDTO(entity: FavoritesUpdateOrder) -> FavoritesUpdateOrderDTO {
        return FavoritesUpdateOrderDTO(symbol: entity.symbol, favoritesOrder: entity.favoritesOrder)
    }
}
