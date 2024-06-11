import Moya
import Foundation

enum UserService {
    case withdraw
    case changeNickname(nickname: String)
    case getUserData
}

extension UserService: TargetType {
    var baseURL: URL { return URL(string: "http://43.200.255.44:8080/api/v1/user/")! }
    var path: String {
        switch self {
        case .withdraw:
            return "out"
        case .changeNickname:
            return "changeNickname"
        case .getUserData:
            return "get"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .withdraw, .changeNickname:
            return .post
        case .getUserData:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .withdraw:
            return .requestPlain
        case .changeNickname(let nickname):
            let parameters = ["nickname": nickname]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getUserData:
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
