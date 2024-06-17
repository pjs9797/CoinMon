import RxFlow

enum SettingStep: Step {
    case navigateToSettingViewController
    case navigateToMyAccountViewController
    case navigateToInquiryViewController
    case navigateToWithdrawalViewController
    case navigateToTermsOfServiceViewController
    case navigateToPrivacyPolicyViewController
    case presentToNetworkErrorAlertController
    case presentToDuplicatedNicknameErrorAlertController
    case presentToLogoutAlertController(reactor: MyAccountReactor)
    case presentToWithdrawAlertController(reactor: WithdrawalReactor)
    case goToAlarmSetting
    case popViewController
    case completeMainFlow
}
