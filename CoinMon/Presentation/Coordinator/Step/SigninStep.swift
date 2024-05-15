import RxFlow

enum SigninStep: Step {
    case navigateToEmailEntryViewController
    case navigateToEmailVerificationNumberViewController
    case popViewController
    case popToRootViewController
    case completeSigninFlow
}
