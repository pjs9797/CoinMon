import RxFlow
import RxCocoa

enum HomeStep: Step {
    case navigateToHomeViewController
    case navigateToNotificationViewController
    case presentToSelectDepartureMarketViewController(selectedMarketRelay: PublishRelay<String>)
    case presentToSelectArrivalMarketViewController(selectedMarketRelay: PublishRelay<String>)
    case presentToNetworkErrorAlertController
    case goToAlarmSetting
    case dismissSelectMarketViewController
    case popViewController
}
