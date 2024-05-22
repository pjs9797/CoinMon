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
    }
    
}

struct Exchanges: Equatable{
    let image: UIImage?
    let title: String
}
