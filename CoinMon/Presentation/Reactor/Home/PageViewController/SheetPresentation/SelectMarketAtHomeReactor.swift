import ReactorKit
import RxCocoa
import RxFlow

class SelectMarketAtHomeReactor: ReactorKit.Reactor,Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    let baseDepartureMarket = [Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Upbit"), localizationKey: "Upbit"),Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bithumb"), localizationKey: "Bithumb")]
    let baseArrivalMarket = [Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Binance"), localizationKey: "Binance"),Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bybit"), localizationKey: "Bybit")]
    var selectedMarketRelay: PublishRelay<String>
    
    init(selectMarketFlow: SelectMarketFlow, selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String){
        self.selectedMarketRelay = selectedMarketRelay
        switch selectMarketFlow{
        case .departure:
            self.initialState = State(markets: baseDepartureMarket, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        case .arrival:
            self.initialState = State(markets: baseArrivalMarket, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        }
    }
    
    enum Action {
        case selectMarket(Int)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var markets: [Market]
        var selectedMarketLocalizationKey: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectMarket(let index):
            selectedMarketRelay.accept(currentState.markets[index].localizationKey)
            self.steps.accept(HomeStep.dismiss)
            return .empty()
        }
    }
}
