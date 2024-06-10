import UIKit.UIImage
import ReactorKit
import RxCocoa
import RxFlow

class SelectMarketReactor: ReactorKit.Reactor,Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    let baseDepartureMarket = [Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Upbit"), localizationKey: "Upbit"),Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bithumb"), localizationKey: "Bithumb")]
    let baseArrivalMarket = [Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Binance"), localizationKey: "Binance"),Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bybit"), localizationKey: "Bybit")]
    var selectMarketFlow: SelectMarketFlow
    var selectedMarketRelay: PublishRelay<String>
    
    init(selectMarketFlow: SelectMarketFlow, selectedMarketRelay: PublishRelay<String>){
        self.selectMarketFlow = selectMarketFlow
        self.selectedMarketRelay = selectedMarketRelay
        switch selectMarketFlow{
        case .departure:
            self.initialState = State(markets: baseDepartureMarket)
        case .arrival:
            self.initialState = State(markets: baseArrivalMarket)
        }
    }
    
    enum Action {
        case selectMarket(Int)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var markets: [Market]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectMarket(let index):
            selectedMarketRelay.accept(currentState.markets[index].localizationKey)
            self.steps.accept(HomeStep.dismissSelectMarketViewController)
            return .empty()
        }
    }
}
