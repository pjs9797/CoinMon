import ReactorKit
import RxCocoa
import RxFlow

class SelectCoinReactor: ReactorKit.Reactor,Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    var selectedCoinRelay: PublishRelay<(String,String)>
    private let coinUseCase: CoinUseCase
    
    init(coinUseCase: CoinUseCase, selectedCoinRelay: PublishRelay<(String,String)>, market: String){
        self.coinUseCase = coinUseCase
        self.selectedCoinRelay = selectedCoinRelay
        initialState = State(market: market)
    }
    
    enum Action {
        case loadCoinData
        case backButtonTapped
        case selectCoin(Int)
    }
    
    enum Mutation {
        case setCoinData([CoinPriceAtAlarm])
    }
    
    struct State {
        var market: String
        var coins: [CoinPriceAtAlarm] = [
            CoinPriceAtAlarm(coinTitle: "BTC", price: "12345.5"),
            CoinPriceAtAlarm(coinTitle: "ETH", price: "5232.5"),
            CoinPriceAtAlarm(coinTitle: "SOL", price: "326"),
            CoinPriceAtAlarm(coinTitle: "BTC", price: "12345.5"),
            CoinPriceAtAlarm(coinTitle: "ETH", price: "5232.5"),
            CoinPriceAtAlarm(coinTitle: "SOL", price: "326"),
            CoinPriceAtAlarm(coinTitle: "BTC", price: "12345.5"),
            CoinPriceAtAlarm(coinTitle: "ETH", price: "5232.5"),
            CoinPriceAtAlarm(coinTitle: "SOL", price: "326"),
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadCoinData:
            return coinUseCase.fetchCoinPriceAtAlarm(exchange: currentState.market)
                .flatMap { coinData -> Observable<Mutation> in
                    return .just(.setCoinData(coinData))
                }
                .catch { [weak self] error in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .selectCoin(let index):
            selectedCoinRelay.accept((currentState.coins[index].coinTitle,currentState.coins[index].price))
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCoinData(let coinData):
            newState.coins = coinData
        }
        return newState
    }
}
