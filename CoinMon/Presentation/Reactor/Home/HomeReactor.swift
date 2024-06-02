import ReactorKit
import RxCocoa
import RxFlow

class HomeReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let baseCategories = ["시세","펀비","김프"]
    
    enum Action {
        case updateLocalizedCategories
        case selectItem(Int)
        case setPreviousIndex(Int)
    }
    
    enum Mutation {
        case setLocalizedCategories([String])
        case setSelectedItem(Int)
        case setPreviousIndex(Int)
    }
    
    struct State {
        var selectedItem: Int = 0
        var previousIndex: Int = 0
        var categories: [String] = [
            LocalizationManager.shared.localizedString(forKey: "시세"),
            LocalizationManager.shared.localizedString(forKey: "펀비"),
            LocalizationManager.shared.localizedString(forKey: "김프")
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateLocalizedCategories:
            let localizedCategories = baseCategories.map { LocalizationManager.shared.localizedString(forKey: $0) }
            return .just(.setLocalizedCategories(localizedCategories))
        case .selectItem(let index):
            return .just(.setSelectedItem(index))
        case .setPreviousIndex(let index):
            return .just(.setPreviousIndex(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLocalizedCategories(let localizedCategories):
            newState.categories = localizedCategories
        case .setSelectedItem(let index):
            newState.selectedItem = index
        case .setPreviousIndex(let index):
            newState.previousIndex = index
        }
        return newState
    }
}
