import Moya
import Foundation

enum PurchaseService {
    case registerReceipt(receiptData: String)
    case getSubscriptionStatus
}

extension PurchaseService: TargetType {
    var baseURL: URL { return URL(string: "http://\(ConfigManager.serverBaseURL)/api/v1/purchase/")! }
    var path: String {
        switch self {
        case .registerReceipt:
            return "registerReceipt"
        case .getSubscriptionStatus:
            return "getSubscriptionStatus"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerReceipt:
            return .post
        case .getSubscriptionStatus:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .registerReceipt(let receiptData):
            let parameters = ["receipt-data": receiptData]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getSubscriptionStatus:
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
