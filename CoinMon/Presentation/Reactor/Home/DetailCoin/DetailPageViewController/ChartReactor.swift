import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class ChartReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    init(market: String, coin: String){
        self.action.onNext(.updateData(market, coin))
    }
    
    enum Action {
        case updateData(String, String)
    }
    
    enum Mutation {
        case setData(String, String)
    }
    
    struct State {
        var urlString: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateData(let market, let coin):
            let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
            let coinTitle = coin+unit
            return .just(.setData(market, coinTitle))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setData(let market, let coin):
            newState.urlString = "https://www.tradingview.com/chart/?symbol=\(market):\(coin)"
        }
        return newState
    }
}
