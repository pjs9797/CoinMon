import RxFlow

enum SigninStep: Step, StepProtocol {
    case navigateToSigninEmailEntryViewController
    case navigateToSigninEmailVerificationNumberViewController
    
    case presentToAuthenticationNumberErrorAlertController
    case presentToNoRegisteredEmailErrorAlertController
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToAWSServerErrorAlertController
    
    case popViewController
    case popToRootViewController
    
    case completeSigninFlow
}
