import Moya
import Foundation

enum CoinService {
    case getCoinData(exchange: String)
    case getOneCoinData(exchange: String, symbol: String)
}

extension CoinService: TargetType {
    var baseURL: URL { return URL(string: "http://52.78.66.213:8080/api/v1/coin/")! }
    var path: String {
        switch self {
        case .getCoinData:
            return "get"
        case .getOneCoinData:
            return "getOne"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCoinData, .getOneCoinData:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getCoinData(let exchange):
            let parameters = ["exchange": exchange]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getOneCoinData(let exchange, let symbol):
            let parameters = ["exchange": exchange, "symbol": symbol]
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
