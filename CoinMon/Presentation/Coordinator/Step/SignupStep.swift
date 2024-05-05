import RxFlow

enum SignupStep: Step {
    case navigateToSignupEmailEntryViewController
    case popViewController
    case completeSignupFlow
}
