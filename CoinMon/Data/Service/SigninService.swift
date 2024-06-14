import Moya
import Foundation

enum SigninService {
    case checkEmail(email: String)
    case loginCode(email: String)
    case login(email: String, number: String, deviceToken: String)
}

extension SigninService: TargetType {
    var baseURL: URL { return URL(string: "http://54.180.226.58:8080/api/v1/user/")! }
    var path: String {
        switch self {
        case .checkEmail:
            return "checkEmail"
        case .loginCode:
            return "loginCode"
        case .login:
            return "login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkEmail, .loginCode, .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .checkEmail(let email):
            let parameters = ["email": email]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .loginCode(let email):
            let parameters = ["email": email]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .login(let email, let number, let deviceToken):
            let parameters = ["email": email, "number": number, "deviceToken": deviceToken]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
