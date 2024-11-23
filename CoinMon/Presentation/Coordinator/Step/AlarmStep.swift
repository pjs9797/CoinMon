import RxFlow
import RxCocoa

enum AlarmStep: Step, StepProtocol {
    case navigateToMainAlarmViewController
    
    case navigateToSelectIndicatorViewController
    case navigateToSelectCoinForIndicatorViewController(flowType: FlowType, indicatorId: String, indicatorName: String, isPremium: Bool)
    case navigateToSelectCycleForIndicatorViewController(flowType: FlowType, selectCycleForIndicatorFlowType: SelectCycleForIndicatorFlowType, indicatorId: String, frequency: String, targets: [String], indicatorName: String, isPremium: Bool)
    case navigateToDetailIndicatorViewController(flowType: String, indicatorId: String, indicatorName: String, isPremium: Bool, frequency: String)
    case navigateToDetailIndicatorCoinViewController(indicatorId: String, indicatorCoinId: String, coin: String, price: String, indicatorName: String, frequency: String)
    case navigateToUpdateIndicatorCoinViewController(indicatorId: String, indicatorName: String, frequency: String)
    case navigateToSelectCoinForUpdateIndicatorViewController(indicatorId: String, indicatorName: String, isPremium: Bool, selectCoinRelay: BehaviorRelay<[UpdateSelectedIndicatorCoin]>)
    
    case navigateToAddAlarmViewController
    case navigateToModifyAlarmViewController(market: String, alarm: Alarm)
    
    case presentToIsRealPopViewController
    
    // 테스트 알림
    case presentToIsReceivedTestAlarmViewController
    case presentToIsNotSetTestAlarmViewController
    case presentToResendTestAlarmViewController
    
    case presentToExplainIndicatorSheetPresentationController(indicatorId: String)
    case presentToDeleteIndicatorPushSheetPresentationController(indicatorId: String, indicatorName: String, flowType: String)
    case presentToMoreButtonAtIndicatorSheetPresentationController(indicatorId: String, indicatorName: String, frequency: String)
        
    case presentToSelectMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case navigateToSelectCoinViewController(selectedCoinRelay: PublishRelay<(String,String)>, market: String)
    case presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: PublishRelay<Int>)
    case presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: PublishRelay<String>)
    
    case presentToRestrictedAlarmErrorAlertController
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController(message: String)
    case presentToExpiredTokenErrorAlertController
    case presentToAWSServerErrorAlertController
    
    case goToPurchaseFlow
    
    case goToAlarmSetting
    case goToKakaoOpenURL(url: String, fallbackUrl: String)
    
    case dismissSheetPresentationController
    case popViewController
    case popToRootViewController
    case endFlow
}
