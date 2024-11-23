import RxFlow
import RxCocoa

enum HomeStep: Step, StepProtocol {
    //MARK: 푸시
    case navigateToHomeViewController
    case navigateToNotificationViewController
    case navigateToDetailCoinInfoViewController(market: String, coin: String)
    case navigateToSelectCoinAtDetailViewController(market: String)
    case navigateToEditFavoritesViewController
    
    //MARK: 프레젠트
    case presentToSelectDepartureMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case presentToSelectArrivalMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String)
    case presentToUnsavedFavoritesSheetPresentationController
    case presentToUnsavedFavoritesSecondSheetPresentationController
    
    //MARK: 설정앱 이동
    case goToAlarmSetting
    
    //MARK: 뒤로가기
    case dismiss
    case popViewController
    case dismissAndPopViewController
    
    //MARK: 플로우 종료
    case endFlow
    
    //MARK: 프레젠트 공통 알람
    case presentToNetworkErrorAlertController
    case presentToUnknownErrorAlertController(message: String)
    case presentToExpiredTokenErrorAlertController
    case presentToAWSServerErrorAlertController
}
