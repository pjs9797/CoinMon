import Foundation
import Moya

enum AppError: Error {
    case network(NSError)
    case awsServerError
    case serverError(statusCode: Int)
    case authenticationError
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .awsServerError:
            return "AWS server is currently unavailable."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)"
        case .authenticationError:
            return "Authentication error. Please log in again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

class ErrorHandler {
    static func handle<T: StepProtocol>(_ error: Error, completion: (T) -> Void) {
        let appError = mapToAppError(error)
        logError(appError)
        let step = stepForError(appError, stepType: T.self)
        completion(step!)
    }
    
    private static func mapToAppError(_ error: Error) -> AppError {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .underlying(let nsError as NSError, _):
                print("Network Error Code: \(nsError.code)")  // 오류 코드 로그 추가
                if nsError.code == 13 {
                    return .awsServerError
                }
                return .network(nsError)
            case .statusCode(let response):
                if response.statusCode == 403 {
                    return .authenticationError
                } else {
                    return .serverError(statusCode: response.statusCode)
                }
            default:
                return .unknown
            }
        } else {
            return .unknown
        }
    }
    
    private static func logError(_ error: AppError) {
        switch error {
        case .serverError(let statusCode):
            print("Error occurred: \(error.localizedDescription). Status code: \(statusCode)")
        default:
            print("Error occurred: \(error.localizedDescription)")
        }
    }
    
    private static func stepForError<T: StepProtocol>(_ error: AppError, stepType: T.Type) -> T? {
        switch error {
        case .network(let nsError) where nsError.code == NSURLErrorNotConnectedToInternet:
            return presentToNetworkErrorAlertController(for: stepType)
        case .awsServerError:
            return presentToAWSServerErrorAlertController(for: stepType)
        case .authenticationError:
            return presentToExpiredTokenErrorAlertController(for: stepType)
        default:
            return presentToUnknownErrorAlertController(for: stepType)
        }
    }
    
    private static func presentToNetworkErrorAlertController<T: StepProtocol>(for stepType: T.Type) -> T? {
        switch stepType {
        case is AppStep.Type: return AppStep.presentToNetworkErrorAlertController as? T
        case is SignupStep.Type: return SignupStep.presentToNetworkErrorAlertController as? T
        case is SigninStep.Type: return SigninStep.presentToNetworkErrorAlertController as? T
        case is HomeStep.Type: return HomeStep.presentToNetworkErrorAlertController as? T
        case is AlarmStep.Type: return AlarmStep.presentToNetworkErrorAlertController as? T
        case is SettingStep.Type: return SettingStep.presentToNetworkErrorAlertController as? T
        default: return nil
        }
    }
    
    private static func presentToAWSServerErrorAlertController<T: StepProtocol>(for stepType: T.Type) -> T? {
        switch stepType {
        case is AppStep.Type: return AppStep.presentToAWSServerErrorAlertController as? T
        case is SignupStep.Type: return SignupStep.presentToAWSServerErrorAlertController as? T
        case is SigninStep.Type: return SigninStep.presentToAWSServerErrorAlertController as? T
        case is HomeStep.Type: return HomeStep.presentToAWSServerErrorAlertController as? T
        case is AlarmStep.Type: return AlarmStep.presentToAWSServerErrorAlertController as? T
        case is SettingStep.Type: return SettingStep.presentToAWSServerErrorAlertController as? T
        default: return nil
        }
    }

    
    private static func presentToExpiredTokenErrorAlertController<T: StepProtocol>(for stepType: T.Type) -> T? {
        switch stepType {
        case is HomeStep.Type: return HomeStep.presentToExpiredTokenErrorAlertController as? T
        case is AlarmStep.Type: return AlarmStep.presentToExpiredTokenErrorAlertController as? T
        case is SettingStep.Type: return SettingStep.presentToExpiredTokenErrorAlertController as? T
        default: return presentToUnknownErrorAlertController(for: stepType)
        }
    }
    
    private static func presentToUnknownErrorAlertController<T: StepProtocol>(for stepType: T.Type) -> T? {
        switch stepType {
        case is AppStep.Type: return AppStep.presentToUnknownErrorAlertController as? T
        case is SignupStep.Type: return SignupStep.presentToUnknownErrorAlertController as? T
        case is SigninStep.Type: return SigninStep.presentToUnknownErrorAlertController as? T
        case is HomeStep.Type: return HomeStep.presentToUnknownErrorAlertController as? T
        case is AlarmStep.Type: return AlarmStep.presentToUnknownErrorAlertController as? T
        case is SettingStep.Type: return SettingStep.presentToUnknownErrorAlertController as? T
        default: return nil
        }
    }
}
