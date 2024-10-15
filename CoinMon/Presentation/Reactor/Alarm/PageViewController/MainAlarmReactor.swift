import ReactorKit
import RxCocoa
import RxFlow

class MainAlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let baseCategories = ["지표","지정가"]
    
    enum Action {
        case updateLocalizedCategories
        case selectItem(Int)
        case setPreviousIndex(Int)
        case inquiryButtonTapped
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
            LocalizationManager.shared.localizedString(forKey: "지표"),
            LocalizationManager.shared.localizedString(forKey: "지정가")
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
        case .inquiryButtonTapped:
            return .empty()
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
