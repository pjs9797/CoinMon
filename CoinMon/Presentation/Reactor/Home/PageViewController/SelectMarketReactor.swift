import UIKit.UIImage
import ReactorKit
import RxCocoa
import RxFlow

class SelectMarketReactor: ReactorKit.Reactor,Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    let baseDepartureMarket = [Market(image: ImageManager.upbit, title: "업비트"),Market(image: ImageManager.bithumb, title: "빗썸")]
    let baseArrivalMarket = [Market(image: ImageManager.binance, title: "바이낸스"),Market(image: ImageManager.bybit, title: "바이비트")]
    var selectMarketFlow: SelectMarketFlow
    
    init(selectMarketFlow: SelectMarketFlow){
        self.selectMarketFlow = selectMarketFlow
        
        switch selectMarketFlow{
        case .departure:
            self.initialState = State(markets: baseDepartureMarket)
        case .arrival:
            self.initialState = State(markets: baseArrivalMarket)
        }
    }
    
    enum Action {
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var markets: [Market]
    }
}
