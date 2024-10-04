struct CoinDetailResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: CoinDetailDataDTO
    
    static func toDetailBasicInfo(dto: CoinDetailResponseDTO) -> DetailBasicInfo {
        let isPush: Bool
        if let push = dto.data.push {
            isPush = push.useYn == "Y" && dto.data.isPush
        } 
        else {
            isPush = false
        }
        if let favorites = dto.data.favorites {
            return DetailBasicInfo(
                favoritesId: favorites.id,
                isPush: isPush,
                isFavorites: dto.data.isFavorites,
                lastPrice1: dto.data.info.lastPrice1
            )
        }
        else {
            return DetailBasicInfo(
                favoritesId: nil,
                isPush: isPush,
                isFavorites: dto.data.isFavorites,
                lastPrice1: dto.data.info.lastPrice1
            )
        }
    }
    
    static func toDetailPriceInfo(dto: CoinDetailResponseDTO) -> DetailPriceInfo {
        let lowHighPrice = LowHighPrice(
            low: dto.data.info.lowPrice,
            high: dto.data.info.highPrice
        )
        
        let historicalPrices = HistoricalPrices(
            lastPrice1: dto.data.info.lastPrice1,
            lastPrice7: dto.data.info.lastPrice7,
            lastPrice30: dto.data.info.lastPrice30,
            lastPrice90: dto.data.info.lastPrice90,
            lastPrice365: dto.data.info.lastPrice365
        )
        
        return DetailPriceInfo(
            lowHighPrice: lowHighPrice,
            historicalPrices: historicalPrices
        )
    }
}

struct CoinDetailDataDTO: Codable {
    let isPush: Bool
    let isFavorites: Bool
    let push: PushDTO?
    let favorites: FavoritesDTO?
    let info: CoinDetailInfoDTO
}

struct PushDTO: Codable {
    let pushId: Int
    let email: String
    let exchange: String
    let symbol: String
    let targetPrice: String
    let frequency: String
    let filter: String
    let useYn: String
    let expTime: [Int]
}

struct FavoritesDTO: Codable {
    let id: Int
    let user: String
    let symbol: String
    let market: String
    let favoritesOrder: Int
    let registerTime: [Int]
}

struct CoinDetailInfoDTO: Codable {
    let market: String
    let tradeVolume: String
    let symbol: String
    let lastPrice1: String
    let lastPrice365: String
    let lowPrice: String
    let lastPrice30: String
    let highPrice: String
    let lastPrice7: String
    let lastPrice90: String
}
