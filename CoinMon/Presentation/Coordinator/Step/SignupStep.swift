import RxFlow

enum SignupStep: Step {
    case navigateToSignupEmailEntryViewController
    case navigateToSignupPhoneNumberEntryViewController
    case presentToTermsOfServiceViewController
    case navigateToVerificationNumberViewController
    case navigateToSignupCompletedViewController
    case popViewController
    case popToRootViewController
    case completeSignupFlow
}
