import RxFlow

enum SettingStep: Step {
    case navigateToSettingViewController
    case navigateToMyAccountViewController
    case navigateToWithdrawalViewController
    case navigateToTermsOfServiceViewController
    case navigateToPrivacyPolicyViewController
    case popViewController
}
