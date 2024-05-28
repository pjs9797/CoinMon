import RxFlow

enum HomeStep: Step {
    case navigateToHomeViewController
    case presentToSelectDepartureExchangeViewController
    case presentToSelectArrivalExchangeViewController
    case dismissSelectExchangeViewController
}
