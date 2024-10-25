import Moya
import Foundation

enum IndicatorService {
    case getIndicator
    case getIndicatorPush
    case getIndicatorCoinList(indicatorId: String)
    case createIndicatorPush(indicatorId: String, frequency: String, targets: [String])
}

extension IndicatorService: TargetType {
    var baseURL: URL { return URL(string: "http://\(ConfigManager.serverBaseURL)/api/v1/")! }
    
    var path: String {
        switch self {
        case .getIndicator:
            return "indicator/getIndicator"
        case .getIndicatorPush:
            return "indicatorPush/getIndicatorPush"
        case .getIndicatorCoinList:
            return "indicator/getIndicatorCoinList"
        case .createIndicatorPush:
            return "indicatorPush/createIndicatorPush"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getIndicator, .getIndicatorPush, .getIndicatorCoinList, .createIndicatorPush:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getIndicator, .getIndicatorPush:
            return .requestPlain
        case .getIndicatorCoinList(let indicatorId):
            let parameters = ["indicatorId": indicatorId]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .createIndicatorPush(let indicatorId, let frequency, let targets):
            let parameters = ["indicatorId": indicatorId, "frequency": frequency, "targets": targets] as [String : Any]
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
