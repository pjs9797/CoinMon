import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class ChartReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        //case viewInfoButtonTapped
        case receiveNotiButtonTapped
        case updateData(String, String, [Double])
    }
    
    enum Mutation {
        case setData(String, String, [Double])
    }
    
    struct State {
        var urlString: String?
        var priceChangeList: [PriceChange] = [
            PriceChange(title: LocalizationManager.shared.localizedString(forKey: "24시간"), priceChange: 3.12),
            PriceChange(title: LocalizationManager.shared.localizedString(forKey: "7일"), priceChange: 3.12),
            PriceChange(title: LocalizationManager.shared.localizedString(forKey: "30일"), priceChange: 3.12),
            PriceChange(title: LocalizationManager.shared.localizedString(forKey: "90일"), priceChange: 3.12),
            PriceChange(title: LocalizationManager.shared.localizedString(forKey: "1년"), priceChange: 3.12),
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .receiveNotiButtonTapped:
            return .empty()
        case .updateData(let market, let coin, let priceChange):
            let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
            let coinTitle = coin+unit
            return .just(.setData(market, coinTitle, priceChange))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setData(let market, let coin, let priceChange):
            newState.urlString = "https://www.tradingview.com/chart/?symbol=\(market):\(coin)"
            newState.priceChangeList[0].priceChange = priceChange[0]
            newState.priceChangeList[1].priceChange = priceChange[1]
            newState.priceChangeList[2].priceChange = priceChange[2]
            newState.priceChangeList[3].priceChange = priceChange[3]
            newState.priceChangeList[4].priceChange = priceChange[4]
        }
        return newState
    }
}
