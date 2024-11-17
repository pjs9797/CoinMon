import Moya
import Foundation

enum IndicatorService {
    case getIndicator
    case getIndicatorPush
    case getIndicatorPushDetail(indicatorId: String)
    case getIndicatorCoinList(indicatorId: String)
    case updateIndicatorPush(indicatorId: String, frequency: String, targets: [String])
    case updateIndicatorPushState(indicatorId: String, isOn: String)
    case createIndicatorPush(indicatorId: String, frequency: String, targets: [String])
    case getIndicatorCoinHistory(indicatorId: String, indicatorCoinId: String)
    case deleteIndicatorPush(indicatorId: String)
}

extension IndicatorService: TargetType {
    var baseURL: URL { return URL(string: "http://\(ConfigManager.serverBaseURL)/api/v1/")! }
    
    var path: String {
        switch self {
        case .getIndicator:
            return "indicator/getIndicator"
        case .getIndicatorPush:
            return "indicatorPush/getIndicatorPush"
        case .getIndicatorPushDetail:
            return "indicatorPush/getIndicatorPushDetail"
        case .getIndicatorCoinList:
            return "indicator/getIndicatorCoinList"
        case .updateIndicatorPush:
            return "indicatorPush/updateIndicatorPush"
        case .updateIndicatorPushState:
            return "indicatorPush/updateIndicatorPushState"
        case .createIndicatorPush:
            return "indicatorPush/createIndicatorPush"
        case .getIndicatorCoinHistory:
            return "indicator/getIndicatorCoinInfo"
        case .deleteIndicatorPush:
            return "indicatorPush/deleteIndicatorPush"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getIndicator, .getIndicatorPush, .getIndicatorPushDetail, .getIndicatorCoinList, .updateIndicatorPush, .updateIndicatorPushState, .createIndicatorPush, .getIndicatorCoinHistory, .deleteIndicatorPush:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getIndicator, .getIndicatorPush:
            return .requestPlain
        case .getIndicatorPushDetail(let indicatorId):
            let parameters = ["indicatorId": indicatorId]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getIndicatorCoinList(let indicatorId):
            let parameters = ["indicatorId": indicatorId]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateIndicatorPush(let indicatorId, let frequency, let targets):
            let parameters = ["indicatorId": indicatorId, "frequency": frequency, "targets": targets] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateIndicatorPushState(let indicatorId, let isOn):
            let parameters = ["indicatorId": indicatorId, "isOn": isOn]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .createIndicatorPush(let indicatorId, let frequency, let targets):
            let parameters = ["indicatorId": indicatorId, "frequency": frequency, "targets": targets] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getIndicatorCoinHistory(let indicatorId, let indicatorCoinId):
            let parameters = ["indicatorId": indicatorId, "indicatorCoinId": indicatorCoinId]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deleteIndicatorPush(let indicatorId):
            let parameters = ["indicatorId": indicatorId]
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
