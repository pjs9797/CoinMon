import RxFlow
import RxCocoa

enum AlarmStep: Step {
    case navigateToAlarmViewController
    case navigateToAddAlarmViewController
    case presentToSelectMarketViewController(selectedMarketRelay: PublishRelay<String>)
    case navigateToSelectCoinViewController(selectedCoinRelay: PublishRelay<(String,String)>, market: String)
    case presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: PublishRelay<Int>)
    case presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: PublishRelay<String>)
    case presentToNetworkErrorAlertController
    case presentToRestrictedAlarmErrorAlertController
    case dismissSheetPresentationController
    case popViewController
}
