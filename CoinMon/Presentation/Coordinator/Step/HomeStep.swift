import RxFlow
import RxCocoa

enum HomeStep: Step {
    case navigateToHomeViewController
    case navigateToNotificationViewController
    case navigateToDetailCoinInfoViewController(market: String, coin: String)
    case navigateToSelectCoinAtDetailViewController(market: String)
    case navigateToEditFavoritesViewController
    case presentToSelectDepartureMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case presentToSelectArrivalMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case presentToUnsavedFavoritesSheetPresentationController
    case presentToUnsavedFavoritesSecondSheetPresentationController
    case presentToNetworkErrorAlertController
    case goToAlarmSetting
    case dismiss
    case popViewController
    case dismissAndPopViewController
}
