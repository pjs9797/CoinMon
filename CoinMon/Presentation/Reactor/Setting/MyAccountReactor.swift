import ReactorKit
import RxCocoa
import RxFlow

class MyAccountReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case backButtonTapped
        case changeNicknameButtonTapped
        case logoutButtonTapped
        case withdrawalButtonTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SettingStep.popViewController)
            return .empty()
        case .changeNicknameButtonTapped:
            return .empty()
        case .logoutButtonTapped:
            return .empty()
        case .withdrawalButtonTapped:
            self.steps.accept(SettingStep.navigateToWithdrawalViewController)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}
