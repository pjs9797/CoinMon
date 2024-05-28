import UIKit.UIImage
import ReactorKit
import RxCocoa
import RxFlow

class SelectExchangeReactor: ReactorKit.Reactor,Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    var selectExchangeFlow: SelectExchangeFlow
    
    init(selectExchangeFlow: SelectExchangeFlow){
        self.selectExchangeFlow = selectExchangeFlow
        
        switch selectExchangeFlow{
        case .departure:
            self.initialState = State(exchanges: [
                Exchanges(image: ImageManager.upbit, title: LocalizationManager.shared.localizedString(forKey: "업비트")),
                Exchanges(image: ImageManager.bithumb, title: LocalizationManager.shared.localizedString(forKey: "빗썸"))
            ])
        case .arrival:
            self.initialState = State(exchanges: [
                Exchanges(image: ImageManager.binance, title: LocalizationManager.shared.localizedString(forKey: "바이낸스")),
                Exchanges(image: ImageManager.bybit, title: LocalizationManager.shared.localizedString(forKey: "바이비트"))
            ])
        }
    }
    
    enum Action {
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var exchanges: [Exchanges]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .departureExchangeButtonTapped:
            return .empty()
        case .arrivalExchangeButtonTapped:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedItem(let index):
            newState.selectedItem = index
        }
        return newState
    }
}
