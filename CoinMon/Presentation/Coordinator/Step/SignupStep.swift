import RxFlow

enum SignupStep: Step, StepProtocol {
    //MARK: 푸시
    case navigateToSignupEmailEntryViewController
    case navigateToSignupEmailVerificationNumberViewController
    case navigateToSignupPhoneNumberEntryViewController
    case navigateToTermsOfServiceViewController
    case navigateToPrivacyPolicyViewController
    case navigateToMarketingConsentViewController
    case navigateToPhoneVerificationNumberViewController
    case navigateToSignupCompletedViewController
    
    //MARK: 프레젠트
    case presentToAgreeToTermsOfServiceViewController
    case presentToAuthenticationNumberErrorAlertController
    case presentToAlreadysubscribedNumberErrorAlertController
    
    //MARK: 뒤로가기
    case dismiss
    case popViewController
    case popToRootViewController
    
    //MARK: 플로우 종료
    case completeSignupFlow
    
    //MARK: 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController(message: String)
    case presentToAWSServerErrorAlertController
}
