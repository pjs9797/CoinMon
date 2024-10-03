import Moya
import Foundation

enum FavoritesService {
    case createFavorites(market: String, symbol: String)
    case fetchFavorites(market: String)
    case deleteFavorites(favoritesId: String)
    case updateFavorites(market: String, favoritesUpdateOrder: [FavoritesUpdateOrderDTO])
}

extension FavoritesService: TargetType {
    var baseURL: URL { return URL(string: "http://\(ConfigManager.serverBaseURL)/api/v1/favorites/")! }
    var path: String {
        switch self {
        case .createFavorites:
            return "create"
        case .fetchFavorites:
            return "select"
        case .deleteFavorites:
            return "delete"
        case .updateFavorites:
            return "updateOrder"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createFavorites, .fetchFavorites, .deleteFavorites, .updateFavorites:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createFavorites(let market, let symbol):
            let parameters = ["market": market, "symbol": symbol]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .fetchFavorites(let market):
            let parameters = ["market": market]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deleteFavorites(let favoritesId):
            let parameters = ["favoritesId": favoritesId]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateFavorites(let market, let favoritesUpdateOrder):
            let orderDicts = favoritesUpdateOrder.map { ["symbol": $0.symbol, "favoritesOrder": $0.favoritesOrder] }
            let parameters = ["market": market, "orders": orderDicts] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.shared.loadAccessToken(), let refreshToken = TokenManager.shared.loadRefreshToken() {
            return ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)", "Authorization-refresh": "Bearer \(refreshToken)"]
        }
        return ["Content-Type": "application/json"]
    }
}
