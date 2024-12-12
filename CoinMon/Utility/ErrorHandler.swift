import Foundation
import RxSwift
import Moya

enum AppError: Error {
    case network(NSError)
    case awsServerError
    case StatusError(statusCode: Int)
    case authenticationError
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .network(let error):
            return "Network error: \(error.localizedDescription)"
        case .awsServerError:
            return "AWS server is currently unavailable."
        case .StatusError(let statusCode):
            return "Error with status code: \(statusCode)"
        case .authenticationError:
            return "Authentication error. Please log in again."
        case .unknown(let error):
            return "Error occurred: \(error.localizedDescription)"
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
                switch nsError.code {
                case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost:
                    return .network(nsError)
                default:
                    return .awsServerError
                }
            case .statusCode(let response):
                if response.statusCode == 403 {
                    return .authenticationError
                } else {
                    return .StatusError(statusCode: response.statusCode)
                }
            default:
                return .unknown(moyaError)
            }
        } else {
            return .unknown(error)
        }
    }
    
    private static func logError(_ error: AppError) {
        switch error {
        case .StatusError(let statusCode):
            print("Error occurred: \(error.localizedDescription). Status code: \(statusCode)")
        default:
            print("Error occurred: \(error.localizedDescription)")
        }
    }
    
    private static func stepForError<T: StepProtocol>(_ error: AppError, stepType: T.Type) -> T? {
        let errorMessage = error.localizedDescription
        switch error {
        case .network(let nsError) where nsError.code == NSURLErrorNotConnectedToInternet:
            return presentToNetworkErrorAlertController(for: stepType)
        case .awsServerError:
            return presentToAWSServerErrorAlertController(for: stepType)
        case .authenticationError:
            return presentToExpiredTokenErrorAlertController(for: stepType)
        case .StatusError:
            return nil
        default:
            return presentToUnknownErrorAlertController(for: stepType, message: errorMessage)
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
        case is PurchaseStep.Type: return PurchaseStep.presentToNetworkErrorAlertController as? T
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
        case is PurchaseStep.Type: return PurchaseStep.presentToAWSServerErrorAlertController as? T
        default: return nil
        }
    }

    
    private static func presentToExpiredTokenErrorAlertController<T: StepProtocol>(for stepType: T.Type) -> T? {
        switch stepType {
        case is HomeStep.Type: return HomeStep.presentToExpiredTokenErrorAlertController as? T
        case is AlarmStep.Type: return AlarmStep.presentToExpiredTokenErrorAlertController as? T
        case is SettingStep.Type: return SettingStep.presentToExpiredTokenErrorAlertController as? T
        case is PurchaseStep.Type: return PurchaseStep.presentToExpiredTokenErrorAlertController as? T
        default: return presentToUnknownErrorAlertController(for: stepType, message: "에러 발생")
        }
    }
    
    private static func presentToUnknownErrorAlertController<T: StepProtocol>(for stepType: T.Type, message: String) -> T? {
        switch stepType {
        case is AppStep.Type: return AppStep.presentToUnknownErrorAlertController(message: message) as? T
        case is SignupStep.Type: return SignupStep.presentToUnknownErrorAlertController(message: message) as? T
        case is SigninStep.Type: return SigninStep.presentToUnknownErrorAlertController(message: message) as? T
        case is HomeStep.Type: return HomeStep.presentToUnknownErrorAlertController(message: message) as? T
        case is AlarmStep.Type: return AlarmStep.presentToUnknownErrorAlertController(message: message) as? T
        case is SettingStep.Type: return SettingStep.presentToUnknownErrorAlertController(message: message) as? T
        case is PurchaseStep.Type: return PurchaseStep.presentToUnknownErrorAlertController(message: message) as? T
        default: return nil
        }
    }
}
