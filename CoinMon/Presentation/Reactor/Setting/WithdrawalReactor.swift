import ReactorKit
import RxCocoa
import RxFlow

class WithdrawalReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case backButtonTapped
        case checkButtonTapped
    }
    
    enum Mutation {
        case setChecked
    }
    
    struct State {
        var isChecked: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SettingStep.popViewController)
            return .empty()
        case .checkButtonTapped:
            return .just(.setChecked)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setChecked:
            newState.isChecked = !newState.isChecked
        }
        return newState
    }
}
