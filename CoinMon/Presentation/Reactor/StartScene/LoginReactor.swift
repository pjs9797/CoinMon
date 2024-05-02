import ReactorKit
import RxCocoa
import RxFlow

class LoginReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case coinMonLoginButtonTapped
        case signupButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .coinMonLoginButtonTapped:
            return .empty()
        case .signupButtonTapped:
            return .empty()
        }
    }
}
