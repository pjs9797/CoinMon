import RxFlow

enum SigninStep: Step {
    case navigateToSigninEmailEntryViewController
    case navigateToEmailVerificationNumberViewController
    case popViewController
    case popToRootViewController
    case completeSigninFlow
}
