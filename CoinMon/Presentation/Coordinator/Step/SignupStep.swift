import RxFlow

enum SignupStep: Step, StepProtocol {
    case navigateToSignupEmailEntryViewController
    case navigateToSignupEmailVerificationNumberViewController
    case navigateToSignupPhoneNumberEntryViewController
    case presentToAgreeToTermsOfServiceViewController
    case navigateToTermsOfServiceViewController
    case navigateToPrivacyPolicyViewController
    case navigateToMarketingConsentViewController
    case navigateToPhoneVerificationNumberViewController
    case navigateToSignupCompletedViewController
    
    
    case presentToAuthenticationNumberErrorAlertController
    case presentToAlreadysubscribedNumberErrorAlertController
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToAWSServerErrorAlertController
    
    case popViewController
    case popToRootViewController
    case dismissViewController
    
    case completeSignupFlow
}
