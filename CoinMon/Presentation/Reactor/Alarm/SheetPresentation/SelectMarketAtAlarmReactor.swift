import ReactorKit
import RxCocoa
import RxFlow

class SelectMarketAtAlarmReactor: ReactorKit.Reactor,Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    var selectedMarketRelay: PublishRelay<String>
    
    init(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String){
        self.selectedMarketRelay = selectedMarketRelay
        initialState = State(selectedMarketLocalizationKey: selectedMarketLocalizationKey)
    }
    
    enum Action {
        case selectMarket(Int)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var markets: [Market] = [
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Binance"), localizationKey: "Binance"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bybit"), localizationKey: "Bybit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Upbit"), localizationKey: "Upbit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bithumb"), localizationKey: "Bithumb")
        ]
        var selectedMarketLocalizationKey: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectMarket(let index):
            selectedMarketRelay.accept(currentState.markets[index].localizationKey)
            self.steps.accept(AlarmStep.dismissSheetPresentationController)
            return .empty()
        }
    }
}
