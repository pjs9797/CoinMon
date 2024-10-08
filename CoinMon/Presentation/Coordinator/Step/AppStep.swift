import RxFlow

protocol StepProtocol {}

enum AppStep: Step, StepProtocol {
    case navigateToSigninViewController
    case navigateToTabBarController
    
    case presentToLanguageSettingAlertController(reactor: SigninReactor)
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToAWSServerErrorAlertController
    
    case popViewController
    case popToRootViewController
    
    case goToSignupFlow
    case goToSigninFlow
    
    case completeSignupFlow
    case completeSigninFlow
    case completeMainFlow
    case completeMainFlowAfterWithdrawal
}
