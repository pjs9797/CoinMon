import Moya
import Foundation

enum UserService {
    case logout
    case withdraw
    case appleWithdraw(authorizationCode: String)
    case changeNickname(nickname: String)
    case getUserData
}

extension UserService: TargetType {
    var baseURL: URL { return URL(string: "http://\(ConfigManager.serverBaseURL)/api/v1/user/")! }
    var path: String {
        switch self {
        case .logout:
            return "logout"
        case .withdraw:
            return "out"
        case .appleWithdraw:
            return "apple/appleOut"
        case .changeNickname:
            return "changeNickname"
        case .getUserData:
            return "get"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logout, .withdraw, .appleWithdraw, .changeNickname:
            return .post
        case .getUserData:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .logout:
            return .requestPlain
        case .withdraw:
            return .requestPlain
        case .appleWithdraw(let authorizationCode):
            let parameters = ["authorizationCode": authorizationCode]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .changeNickname(let nickname):
            let parameters = ["nickname": nickname]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getUserData:
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
