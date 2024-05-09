import RxFlow

enum SignupStep: Step {
    case navigateToSignupEmailEntryViewController
    case navigateToSignupPhoneNumberEntryViewController
    case navigateToVerificationNumberViewController
    case navigateToSignupCompletedViewController
    case popViewController
    case completeSignupFlow
}
