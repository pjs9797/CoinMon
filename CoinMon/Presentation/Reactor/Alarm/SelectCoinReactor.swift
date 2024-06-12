import ReactorKit
import RxCocoa
import RxFlow

class SelectCoinReactor: ReactorKit.Reactor,Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    var selectedCoinRelay: PublishRelay<(String,String)>
    
    init(selectedCoinRelay: PublishRelay<(String,String)>){
        self.selectedCoinRelay = selectedCoinRelay
    }
    
    enum Action {
        case backButtonTapped
        case selectCoin(Int)
    }
    
    enum Mutation {
        
    }
    
    struct State {
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
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .selectCoin(let index):
            selectedCoinRelay.accept((currentState.coins[index].coinTitle,currentState.coins[index].price))
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        }
    }
}
