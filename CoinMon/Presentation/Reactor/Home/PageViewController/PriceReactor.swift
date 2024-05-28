import UIKit.UIImage
import ReactorKit
import RxCocoa

class PriceReactor: ReactorKit.Reactor {
    let initialState: State = State()
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var exchanges: [Exchanges] = [
            Exchanges(image: ImageManager.binance, title: LocalizationManager.shared.localizedString(forKey: "바이낸스")),
            Exchanges(image: ImageManager.bybit, title: LocalizationManager.shared.localizedString(forKey: "바이비트")),
            Exchanges(image: ImageManager.upbit, title: LocalizationManager.shared.localizedString(forKey: "업비트")),
            Exchanges(image: ImageManager.bithumb, title: LocalizationManager.shared.localizedString(forKey: "빗썸"))
        ]
        var priceList: [PriceList] = [
            PriceList(coinImage: "bybit", coinTitle: "BTC", price: "999999", change: "10.13%", gap: "12.32%"),
            PriceList(coinImage: "bybit", coinTitle: "ETH", price: "123532", change: "15.13%", gap: "1.32%"),
            PriceList(coinImage: "bybit", coinTitle: "XRP", price: "523", change: "-10.13%", gap: "52.32%"),
            PriceList(coinImage: "bybit", coinTitle: "SOL", price: "4442", change: "20.13%", gap: "-22.32%"),
        ]
    }
    
}
