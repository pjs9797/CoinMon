import Moya
import Foundation

enum CoinService {
    case getCoinData
}

extension CoinService: TargetType {
    var baseURL: URL { return URL(string: "http://43.200.255.44:8080/api/v1/user/")! }
    var path: String {
        switch self {
        case .getCoinData:
            return "coin/get"
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
        case .getCoinData:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.shared.loadAccessToken() {
            return ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)"]
        }
        return ["Content-Type": "application/json"]
    }
}
