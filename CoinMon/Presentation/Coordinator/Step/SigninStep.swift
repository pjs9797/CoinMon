import RxFlow

enum SigninStep: Step {
    case navigateToSigninEmailEntryViewController
    case navigateToVerificationNumberViewController
    case popViewController
    case popToRootViewController
    case completeSigninFlow
}
