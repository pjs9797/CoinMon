import RxFlow

enum SigninStep: Step {
    case navigateToSigninEmailEntryViewController
    case navigateToSigninEmailVerificationNumberViewController
    case presentToNetworkErrorAlertController
    case presentToAuthenticationNumberErrorAlertController
    case presentToNoRegisteredEmailErrorAlertController
    case popViewController
    case popToRootViewController
    case completeSigninFlow
}
