import RxFlow
import RxCocoa

enum HomeStep: Step, StepProtocol {
    case navigateToHomeViewController
    case navigateToNotificationViewController
    case navigateToDetailCoinInfoViewController(market: String, coin: String)
    case navigateToSelectCoinAtDetailViewController(market: String)
    case navigateToEditFavoritesViewController
    
    case presentToSelectDepartureMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case presentToSelectArrivalMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case presentToUnsavedFavoritesSheetPresentationController
    case presentToUnsavedFavoritesSecondSheetPresentationController
    
    // 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController
    case presentToExpiredTokenErrorAlertController
    case presentToAWSServerErrorAlertController
    
    case goToAlarmSetting
    
    case presentToNewIndicatorViewController
    case presentToTryNewIndicatorViewController
    
    case dismiss
    case popViewController
    case dismissAndPopViewController
    case endFlow
}
