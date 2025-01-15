import Moya
import Foundation

enum SignupService {
    case checkEmail(email: String)
    case emailCode(email: String)
    case checkEmailCode(email: String, number: String)
    case signup(email: String, userType:String)
}

extension SignupService: TargetType {
    var baseURL: URL { return URL(string: "http://\(ConfigManager.serverBaseURL)/api/v1/user/")! }
    var path: String {
        switch self {
        case .checkEmail:
            return "checkEmail"
        case .emailCode:
            return "emailCode"
        case .checkEmailCode:
            return "checkEmailCode"
        case .signup:
            return "join"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkEmail, .emailCode, .checkEmailCode, .signup:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .checkEmail(let email):
            let parameters = ["email": email]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .emailCode(let email):
            let parameters = ["email": email]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .checkEmailCode(let email, let number):
            let parameters = ["email": email, "number": number]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .signup(let email, let userType):
            let parameters = ["email": email, "userType": userType]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
