import UIKit.UIImage
import ReactorKit
import RxCocoa

class FeeReactor: ReactorKit.Reactor {
    let initialState: State = State()
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var exchanges: [Exchanges] = [
            Exchanges(image: ImageManager.binance, title: LocalizationManager.shared.localizedString(forKey: "바이낸스")),
            Exchanges(image: ImageManager.bybit, title: LocalizationManager.shared.localizedString(forKey: "바이비트"))
        ]
        var feeList: [FeeList] = [
            FeeList(coinImage: "bybit", coinTitle: "BTC", fee: "0.01"),
            FeeList(coinImage: "bybit", coinTitle: "ETH", fee: "0.03"),
            FeeList(coinImage: "bybit", coinTitle: "XRP", fee: "0.05"),
            FeeList(coinImage: "bybit", coinTitle: "SOL", fee: "0.005"),
        ]
    }
    
}
