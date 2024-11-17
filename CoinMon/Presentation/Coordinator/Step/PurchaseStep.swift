import RxFlow

enum SelectCoinForIndicatorFlowType {
    case atPurchase
    case atNotPurchase
}

enum IsRealPopFlowType {
    case atPurchase
    case atNotPurchase
}

enum PurchaseStep: Step, StepProtocol {
    case presentToTryNewIndicatorViewController
    case presentToPurchaseViewController
    case presentToSuccessSubscriptionViewController
    case navigateToSubscriptionManagementViewController
    
    case navigateToSelectCoinForIndicatorViewController(flowType: SelectCoinForIndicatorFlowType, indicatorId: String, indicatorName: String, isPremium: Bool)
    case navigateToSelectCycleForIndicatorViewController(flowType: SelectCycleForIndicatorFlowType, selectCoinForIndicatorFlowType: SelectCoinForIndicatorFlowType, indicatorId: String, frequency: String, targets: [String], indicatorName: String, isPremium: Bool)
    
    case presentToIsRealPopViewController
    
    case presentToSuccessPurchaseAlertController
    case presentToFailurePurchaseAlertController
    case presentToServerFailurePurchaseAlertController
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToExpiredTokenErrorAlertController
    case presentToAWSServerErrorAlertController
    
    case goToAlarmSetting
    case goToOpenURL(url: String, fallbackUrl: String)
    
    case dismiss
    case popWithCustomAnimation
    case popViewController
    
    case endFlow
}
