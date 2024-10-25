import RxFlow
import RxCocoa

enum AlarmStep: Step, StepProtocol {
    case navigateToMainAlarmViewController
    
    case navigateToSelectIndicatorViewController
    case navigateToSelectCoinForIndicatorViewController(indicatorId: String, indicatorName: String, isPremium: Bool)
    case navigateToSelectCycleForIndicatorViewController(indicatorId: String, frequency: String, targets: [String], indicatorName: String, isPremium: Bool)
    
    case navigateToAddAlarmViewController
    case navigateToModifyAlarmViewController(market: String, alarm: Alarm)
    
    case presentToExplainIndicatorSheetPresentationController(indicatorId: String)
    
    case presentToSelectMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case navigateToSelectCoinViewController(selectedCoinRelay: PublishRelay<(String,String)>, market: String)
    case presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: PublishRelay<Int>)
    case presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: PublishRelay<String>)
    
    case presentToRestrictedAlarmErrorAlertController
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToExpiredTokenErrorAlertController
    case presentToAWSServerErrorAlertController
    
    case dismissSheetPresentationController
    case popViewController
    case popToRootViewController
    case endFlow
}
