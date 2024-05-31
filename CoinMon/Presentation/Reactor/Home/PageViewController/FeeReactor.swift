import UIKit.UIImage
import ReactorKit
import RxCocoa

class FeeReactor: ReactorKit.Reactor {
    let initialState: State = State()
    let baseMarkets = [Market(image: ImageManager.upbit, title: "업비트"),Market(image: ImageManager.bithumb, title: "빗썸")]
    
    enum Action {
        case updateLocalizedMarkets
    }
    
    enum Mutation {
        case setLocalizedMarkets([Market])
    }
    
    struct State {
        var markets: [Market] = [
            Market(image: ImageManager.binance, title: LocalizationManager.shared.localizedString(forKey: "업비트")),
            Market(image: ImageManager.bybit, title: LocalizationManager.shared.localizedString(forKey: "빗썸"))
        ]
        var feeList: [FeeList] = [
            FeeList(coinImage: "bybit", coinTitle: "BTC", fee: "0.01"),
            FeeList(coinImage: "bybit", coinTitle: "ETH", fee: "0.03"),
            FeeList(coinImage: "bybit", coinTitle: "XRP", fee: "0.05"),
            FeeList(coinImage: "bybit", coinTitle: "SOL", fee: "0.005"),
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateLocalizedMarkets:
            let localizedMarkets = baseMarkets.map { Market(image: $0.image, title: LocalizationManager.shared.localizedString(forKey: $0.title)) }
            return .just(.setLocalizedMarkets(localizedMarkets))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLocalizedMarkets(let localizedMarkets):
            newState.markets = localizedMarkets
        }
        return newState
    }
}
