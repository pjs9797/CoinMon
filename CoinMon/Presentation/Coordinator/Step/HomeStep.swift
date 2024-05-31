import RxFlow

enum HomeStep: Step {
    case navigateToHomeViewController
    case presentToSelectDepartureMarketViewController
    case presentToSelectArrivalMarketViewController
    case dismissSelectMarketViewController
}
