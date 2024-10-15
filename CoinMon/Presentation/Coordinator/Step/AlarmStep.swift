import RxFlow
import RxCocoa

enum AlarmStep: Step, StepProtocol {
    case navigateToMainAlarmViewController
    case navigateToAddAlarmViewController
    case navigateToModifyAlarmViewController(market: String, alarm: Alarm)
    
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
    case endFlow
}
