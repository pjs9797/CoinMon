import Moya
import Foundation

enum AlarmService {
    case createAlarm(exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String)
    case deleteAlarm(pushId: Int)
    case updateAlarm(pushId: Int, exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String)
    case getAlarms
}

extension AlarmService: TargetType {
    var baseURL: URL { return URL(string: "http://\(ConfigManager.serverBaseURL)/api/v1/push/")! }
    var path: String {
        switch self {
        case .createAlarm:
            return "create"
        case .deleteAlarm:
            return "delete"
        case .updateAlarm:
            return "update"
        case .getAlarms:
            return "get"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createAlarm, .deleteAlarm, .updateAlarm:
            return .post
        case .getAlarms:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .createAlarm(let exchange, let symbol, let targetPrice, let frequency, let useYn, let filter):
            let parameters = ["exchange": exchange, "symbol": symbol, "targetPrice":targetPrice, "frequency":frequency, "useYn":useYn, "filter":filter]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deleteAlarm(let pushId):
            let parameters = ["pushId": pushId]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateAlarm(let pushId, let exchange, let symbol, let targetPrice, let frequency, let useYn, let filter):
            let parameters = ["pushId": pushId, "exchange": exchange, "symbol": symbol, "targetPrice":targetPrice, "frequency":frequency, "useYn":useYn, "filter":filter] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getAlarms:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.shared.loadAccessToken(), let refreshToken = TokenManager.shared.loadRefreshToken() {
            return ["Content-Type": "application/json", "Authorization": "Bearer \(accessToken)", "Authorization-refresh": "Bearer \(refreshToken)"]
        }
        return ["Content-Type": "application/json"]
    }
}
