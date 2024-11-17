import RxFlow

protocol StepProtocol {}

enum AppStep: Step, StepProtocol {
    //MARK: 푸시
    case navigateToSurveyViewController
    case navigateToSigninViewController
    case navigateToTabBarController
    
    //MARK: 프레젠트
    case presentToLanguageSettingAlertController(reactor: SigninReactor)
    case presentToAlreadySignedErrorAlertController
    
    //MARK: 플로우 이동
    case goToPurchaseFlow
    case goToSignupFlow
    case goToSignupFlowForApple
    case goToSigninFlow
    
    //MARK: 플로우 종료
    case completeSignupFlow
    case completeSigninFlow
    case completeMainFlow
    case completeMainFlowAfterWithdrawal
    
    //MARK: 뒤로가기
    case dismiss
    case popViewController
    case popToRootViewController
    
    //MARK: 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToAWSServerErrorAlertController
}
