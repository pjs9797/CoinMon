import RxFlow

enum SettingStep: Step, StepProtocol {
    case navigateToSettingViewController
    case navigateToMyAccountViewController
    case navigateToInquiryViewController
    case navigateToWithdrawalViewController
    case navigateToTermsOfServiceViewController
    case navigateToPrivacyPolicyViewController
    
    case presentToDuplicatedNicknameErrorAlertController
    case presentToLogoutAlertController(reactor: MyAccountReactor)
    case presentToWithdrawAlertController(reactor: WithdrawalReactor)
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToExpiredTokenErrorAlertController
    case presentToAWSServerErrorAlertController
    
    case goToPurchaseFlow
    
    case goToAlarmSetting
    case goToOpenURL(url: String, fallbackUrl: String)
    
    case popViewController
    
    case endFlow
    case endFlowAfterWithdrawal
}
