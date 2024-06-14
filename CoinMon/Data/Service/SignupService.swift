import Moya
import Foundation

enum SignupService {
    case checkEmail(email: String)
    case emailCode(email: String)
    case checkEmailCode(email: String, number: String)
    case phoneCode(phoneNumber: String)
    case checkPhoneCode(phoneNumber: String, number: String)
    case signup(phoneNumber:String, email: String, userType:String)
}

extension SignupService: TargetType {
    var baseURL: URL { return URL(string: "http://54.180.226.58:8080/api/v1/user/")! }
    var path: String {
        switch self {
        case .checkEmail:
            return "checkEmail"
        case .emailCode:
            return "emailCode"
        case .checkEmailCode:
            return "checkEmailCode"
        case .phoneCode:
            return "phoneCode"
        case .checkPhoneCode:
            return "checkPhoneCode"
        case .signup:
            return "join"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkEmail, .emailCode, .checkEmailCode, .phoneCode, .checkPhoneCode, .signup:
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
        case .phoneCode(let phoneNumber):
            let parameters = ["phoneNumber": phoneNumber]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .checkPhoneCode(let phoneNumber, let number):
            let parameters = ["phoneNumber": phoneNumber, "number": number]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .signup(let phoneNumber, let email, let userType):
            let parameters = ["phoneNumber": phoneNumber, "email": email, "userType": userType]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
