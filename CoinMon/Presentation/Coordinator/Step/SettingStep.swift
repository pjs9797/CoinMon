import RxFlow


enum SettingStep: Step, StepProtocol {
    //MARK: 푸시
    case navigateToSettingViewController
    case navigateToMyAccountViewController
    case navigateToInquiryViewController
    case navigateToWithdrawalViewController
    case navigateToTermsOfServiceViewController
    case navigateToPrivacyPolicyViewController
    case navigateToSuccessSubscriptionViewController
    case navigateToSubscriptionManagementViewController
    
    //MARK: 프레젠트
    case presentToDuplicatedNicknameErrorAlertController
    case presentToLogoutAlertController(reactor: MyAccountReactor)
    case presentToWithdrawAlertController(reactor: WithdrawalReactor)
    
    //MARK: 플로우 이동
    case goToPurchaseFlow
    
    //MARK: 설정앱 이동
    case goToAlarmSetting
    
    //MARK: URL 이동
    case goToOpenURL(url: String, fallbackUrl: String)
    
    //MARK: 뒤로가기
    case popDownWithAnimation
    case popViewController
    
    //MARK: 플로우 종료
    case endFlow
    case endFlowAfterWithdrawal
    
    //MARK: 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController(message: String)
    case presentToExpiredTokenErrorAlertController
    case presentToAWSServerErrorAlertController
}
