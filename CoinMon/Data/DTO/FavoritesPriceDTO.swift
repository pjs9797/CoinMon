import Foundation

struct FavoritesResponseDTO: Codable {
    let resultCode: String
    let resultMessage: String
    let data: DataClass?
    
    struct DataClass: Codable {
        let info: [FavoritesPriceDTO]
    }
    
    static func toFavorites(dto: FavoritesResponseDTO) -> [Favorites] {
        return dto.data?.info.map { FavoritesPriceDTO.toFavorites(dto: $0) } ?? []
    }
    
    static func toResultCode(dto: FavoritesResponseDTO) -> String {
        return dto.resultCode
    }
}

struct FavoritesPriceDTO: Codable {
    let id: Int
    let user: String
    let symbol: String
    let market: String
    let favoritesOrder: Int
//    let marketPrice: Double
//    let limitPrice: Double
//    let fundingRate: Double
//    let standardPrice: Double?
//    let percent: Double
    
    static func toFavorites(dto: FavoritesPriceDTO) -> Favorites {
        return Favorites(id: String(dto.id), symbol: dto.symbol, favoritesOrder: dto.favoritesOrder)
    }
}

struct FavoritesUpdateOrderDTO: Codable{
    let symbol: String
    let favoritesOrder: Int
    
    static func toFavoritesUpdateOrderDTO(entity: FavoritesUpdateOrder) -> FavoritesUpdateOrderDTO {
        return FavoritesUpdateOrderDTO(symbol: entity.symbol, favoritesOrder: entity.favoritesOrder)
    }
}
