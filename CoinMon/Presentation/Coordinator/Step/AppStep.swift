import RxFlow

enum AppStep: Step {
    case navigateToSigninViewController
    case navigateToTabBarController
    case presentToLanguageSettingAlertController(reactor: SigninReactor)
    case popViewController
    case popToRootViewController
    case goToSignupFlow
    case goToSigninFlow
    case completeSignupFlow
    case completeSigninFlow
    case completeMainFlow
    case completeMainFlowAfterWithdrawal
}
