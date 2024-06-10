import RxFlow

enum SignupStep: Step {
    case navigateToSignupEmailEntryViewController
    case navigateToSignupEmailVerificationNumberViewController
    case navigateToSignupPhoneNumberEntryViewController
    case presentToAgreeToTermsOfServiceViewController
    case navigateToTermsOfServiceViewController
    case navigateToPrivacyPolicyViewController
    case navigateToMarketingConsentViewController
    case navigateToPhoneVerificationNumberViewController
    case navigateToSignupCompletedViewController
    case presentToNetworkErrorAlertController
    case presentToAuthenticationNumberErrorAlertController
    case presentToAlreadysubscribedNumberErrorAlertController
    case popViewController
    case popToRootViewController
    case dismissViewController
    case completeSignupFlow
}
