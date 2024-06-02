import UIKit.UIImage
import ReactorKit
import RxCocoa
import RxFlow

class SelectMarketReactor: ReactorKit.Reactor,Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    let baseDepartureMarket = [Market(marketTitle: "Upbit", localizationKey: "Upbit"),Market(marketTitle: "Bithumb", localizationKey: "Bithumb")]
    let baseArrivalMarket = [Market(marketTitle: "Binance", localizationKey: "Binance"),Market(marketTitle: "Bybit", localizationKey: "Bybit")]
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
