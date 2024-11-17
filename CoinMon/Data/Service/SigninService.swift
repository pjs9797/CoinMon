import Moya
import Foundation

enum SigninService {
    case checkEmail(email: String)
    case loginCode(email: String)
    case login(email: String, number: String, deviceToken: String)
    case appleLogin(identityToken: String, authorizationCode: String, deviceToken: String)
}

extension SigninService: TargetType {
    var baseURL: URL { return URL(string: "http://\(ConfigManager.serverBaseURL)/api/v1/user/")! }
    var path: String {
        switch self {
        case .checkEmail:
            return "checkEmail"
        case .loginCode:
            return "loginCode"
        case .login:
            return "login"
        case .appleLogin:
            return "apple/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkEmail, .loginCode, .login, .appleLogin:
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
        case .appleLogin(let identityToken, let authorizationCode, let deviceToken):
            let parameters = ["identityToken": identityToken, "authorizationCode": authorizationCode, "deviceToken": deviceToken]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        switch self {
        case .checkEmail(let email):
            if(email == "test@gmail.com"){
                return """
                {
                    "resultCode": "400",
                    "resultMessage": ""
                }
                """.data(using: .utf8)!
            }
            else {
                return """
                {
                    "resultCode": "200",
                    "resultMessage": ""
                }
                """.data(using: .utf8)!
            }
            
        case .loginCode:
            return """
                {
                    "resultCode": "200",
                    "resultMessage": ""
                }
                """.data(using: .utf8)!
            
        case .login(_, let number, _):
            if(number == "102030"){
                return """
                {
                    "resultCode": "200",
                    "resultMessage": "OK",
                    "data": {
                        "imgIndex": "1",
                        "phoneNumber": "1234567890",
                        "nickname": "nickname",
                        "userType": "user",
                        "accessToken": "accessToken",
                        "email": "test@gmail.com",
                        "refreshToken": "refreshToken"
                    }
                }
                """.data(using: .utf8)!
            }
            else{
                return """
                {
                    "resultCode": "400",
                    "resultMessage": ""
                }
                """.data(using: .utf8)!
            }
        case .appleLogin:
            return """
            {
                "resultCode": "200",
                "resultMessage": ""
            }
            """.data(using: .utf8)!
        }
    }
}
