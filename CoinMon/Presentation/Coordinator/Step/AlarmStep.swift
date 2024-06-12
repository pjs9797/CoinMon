import RxFlow
import RxCocoa

enum AlarmStep: Step {
    case navigateToAlarmViewController
    case navigateToAddAlarmViewController
    case presentToSelectMarketViewController(selectedMarketRelay: PublishRelay<String>)
    case navigateToSelectCoinViewController(selectedCoinRelay: PublishRelay<(String,String)>)
    case presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: PublishRelay<Int>)
    case presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: PublishRelay<Int>)
    case presentToNetworkErrorAlertController
    case dismissSheetPresentationController
    case popViewController
}
