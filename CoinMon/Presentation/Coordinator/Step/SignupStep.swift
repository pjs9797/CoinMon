import RxFlow

enum SignupStep: Step {
    case navigateToSignupEmailEntryViewController
    case navigateToSignupPhoneNumberEntryViewController
    case navigateToVerificationNumberViewController
    case popViewController
    case completeSignupFlow
}
