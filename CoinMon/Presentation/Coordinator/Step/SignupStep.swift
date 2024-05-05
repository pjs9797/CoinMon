import RxFlow

enum SignupStep: Step {
    case navigateToSignupEmailEntryViewController
    case navigateToSignupPhoneNumberEntryViewController
    case popViewController
    case completeSignupFlow
}
