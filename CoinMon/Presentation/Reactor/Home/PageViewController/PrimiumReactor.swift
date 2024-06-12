import ReactorKit
import RxCocoa
import RxFlow

class PremiumReactor: ReactorKit.Reactor,Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let selectDepartureMarketRelay = PublishRelay<String>()
    let selectArrivalMarketRelay = PublishRelay<String>()
    
    enum Action {
        case departureMarketButtonTapped
        case arrivalMarketButtonTapped
        case setDepartureMarket(String)
        case setArrivalMarket(String)
    }
    
    enum Mutation {
        case setDepartureMarket(String)
        case setArrivalMarket(String)
    }
    
    struct State {
        var premiumList: [CoinPremium] = [
            CoinPremium(coinTitle: "BTC", premium: "0.01"),
            CoinPremium(coinTitle: "ETH", premium: "0.03"),
            CoinPremium(coinTitle: "XRP", premium: "0.05"),
            CoinPremium(coinTitle: "SOL", premium: "0.005"),
        ]
        var departureMarketButtonTitle: String = "Upbit"
        var arrivalMarketButtonTitle: String = "Binance"
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .departureMarketButtonTapped:
            self.steps.accept(HomeStep.presentToSelectDepartureMarketViewController(selectedMarketRelay: selectDepartureMarketRelay))
            return .empty()
        case .arrivalMarketButtonTapped:
            self.steps.accept(HomeStep.presentToSelectArrivalMarketViewController(selectedMarketRelay: selectArrivalMarketRelay))
            return .empty()
        case .setDepartureMarket(let market):
            return .just(.setDepartureMarket(market))
        case .setArrivalMarket(let market):
            return .just(.setArrivalMarket(market))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setDepartureMarket(let market):
            newState.departureMarketButtonTitle = market
        case .setArrivalMarket(let market):
            newState.arrivalMarketButtonTitle = market
        }
        return newState
    }
}
