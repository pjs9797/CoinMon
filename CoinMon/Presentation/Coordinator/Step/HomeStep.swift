import RxFlow
import RxCocoa

enum HomeStep: Step {
    case navigateToHomeViewController
    case navigateToNotificationViewController
    case navigateToDetailCoinInfoViewController(market: String, coin: String)
    case presentToSelectDepartureMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case presentToSelectArrivalMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case presentToNetworkErrorAlertController
    case goToAlarmSetting
    case dismissSelectMarketViewController
    case popViewController
}
