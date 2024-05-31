import UIKit.UIImage
import ReactorKit
import RxCocoa

class PriceReactor: ReactorKit.Reactor {
    let initialState: State = State()
    let baseMarkets = [Market(image: ImageManager.binance, title: "바이낸스"),Market(image: ImageManager.bybit, title: "바이비트"),Market(image: ImageManager.upbit, title: "업비트"),Market(image: ImageManager.bithumb, title: "빗썸")]
    
    enum Action {
        case updateLocalizedMarkets
    }
    
    enum Mutation {
        case setLocalizedMarkets([Market])
    }
    
    struct State {
        var markets: [Market] = [
            Market(image: ImageManager.binance, title: LocalizationManager.shared.localizedString(forKey: "바이낸스")),
            Market(image: ImageManager.bybit, title: LocalizationManager.shared.localizedString(forKey: "바이비트")),
            Market(image: ImageManager.upbit, title: LocalizationManager.shared.localizedString(forKey: "업비트")),
            Market(image: ImageManager.bithumb, title: LocalizationManager.shared.localizedString(forKey: "빗썸"))
        ]
        var priceList: [PriceList] = [
            PriceList(coinImage: "bybit", coinTitle: "BTC", price: "999999", change: "10.13%", gap: "12.32%"),
            PriceList(coinImage: "bybit", coinTitle: "ETH", price: "123532", change: "15.13%", gap: "1.32%"),
            PriceList(coinImage: "bybit", coinTitle: "XRP", price: "523", change: "-10.13%", gap: "52.32%"),
            PriceList(coinImage: "bybit", coinTitle: "SOL", price: "4442", change: "20.13%", gap: "-22.32%"),
            PriceList(coinImage: "bybit", coinTitle: "BTC", price: "999999", change: "10.13%", gap: "12.32%"),
            PriceList(coinImage: "bybit", coinTitle: "ETH", price: "123532", change: "15.13%", gap: "1.32%"),
            PriceList(coinImage: "bybit", coinTitle: "XRP", price: "523", change: "-10.13%", gap: "52.32%"),
            PriceList(coinImage: "bybit", coinTitle: "SOL", price: "4442", change: "20.13%", gap: "-22.32%"),
            PriceList(coinImage: "bybit", coinTitle: "BTC", price: "999999", change: "10.13%", gap: "12.32%"),
            PriceList(coinImage: "bybit", coinTitle: "ETH", price: "123532", change: "15.13%", gap: "1.32%"),
            PriceList(coinImage: "bybit", coinTitle: "XRP", price: "523", change: "-10.13%", gap: "52.32%"),
            PriceList(coinImage: "bybit", coinTitle: "SOL", price: "4442", change: "20.13%", gap: "-22.32%"),
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
