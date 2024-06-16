import RxFlow
import RxCocoa

enum HomeStep: Step {
    case navigateToHomeViewController
    case presentToSelectDepartureMarketViewController(selectedMarketRelay: PublishRelay<String>)
    case presentToSelectArrivalMarketViewController(selectedMarketRelay: PublishRelay<String>)
    case presentToNetworkErrorAlertController
    case dismissSelectMarketViewController
}
