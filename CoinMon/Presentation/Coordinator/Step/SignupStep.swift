import RxFlow

enum SignupStep: Step {
    case navigateToSignupEmailEntryViewController
    case navigateToEmailVerificationNumberViewController
    case navigateToSignupPhoneNumberEntryViewController
    case presentToTermsOfServiceViewController
    case navigateToPhoneVerificationNumberViewController
    case navigateToSignupCompletedViewController
    case popViewController
    case popToRootViewController
    case dismissViewController
    case completeSignupFlow
}
