import RxFlow

enum PurchaseStep: Step, StepProtocol {
    case navigateToTryNewIndicatorViewController
    case navigateToPurchaseViewController
    case navigateToSuccessSubscriptionViewController
    case navigateToSubscriptionManagementViewController
    
    case navigateToSelectCoinForIndicatorViewController(flowType: FlowType, indicatorId: String, indicatorName: String, isPremium: Bool)
    case navigateToSelectCycleForIndicatorViewController(flowType: FlowType, selectCycleForIndicatorFlowType: SelectCycleForIndicatorFlowType, indicatorId: String, frequency: String, targets: [String], indicatorName: String, isPremium: Bool)
    
    case presentToIsRealPopViewController
    
    case presentToSuccessPurchaseAlertController
    case presentToFailurePurchaseAlertController
    case presentToServerFailurePurchaseAlertController
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController(message: String)
    case presentToExpiredTokenErrorAlertController
    case presentToAWSServerErrorAlertController
    
    case goToAlarmSetting
    case goToOpenURL(url: String, fallbackUrl: String)
    
    case dismiss
    case popWithCustomAnimation
    case popViewController
    case popToRootViewController
    
    case endFlow
}
