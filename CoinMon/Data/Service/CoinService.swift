import Moya
import Foundation

enum CoinService {
    case getCoinData(exchange: String)
}

extension CoinService: TargetType {
    var baseURL: URL { return URL(string: "http://54.180.226.58:8080/api/v1/coin/")! }
    var path: String {
        switch self {
        case .getCoinData:
            return "get"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCoinData:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getCoinData(let exchange):
            let parameters = ["exchange": exchange]
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
