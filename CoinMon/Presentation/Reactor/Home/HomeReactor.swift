import ReactorKit
import RxCocoa
import RxFlow

class HomeReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case selectItem(Int)
    }
    
    enum Mutation {
        case setSelectedItem(Int)
    }
    
    struct State {
        var selectedItem: Int = 0
        var categories: [String] = [
            LocalizationManager.shared.localizedString(forKey: "시세"),
            LocalizationManager.shared.localizedString(forKey: "펀비"),
            LocalizationManager.shared.localizedString(forKey: "김프")
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectItem(let index):
            return .just(.setSelectedItem(index))
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
