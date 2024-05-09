import ReactorKit
import RxCocoa
import RxFlow

class SigninReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case coinMonLoginButtonTapped
        case signupButtonTapped
    }
    
    enum Mutation {}
    
    struct State {}
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .coinMonLoginButtonTapped:
            self.steps.accept(AppStep.goToSigninFlow)
            return .empty()
        case .signupButtonTapped:
            self.steps.accept(AppStep.goToSignupFlow)
            return .empty()
        }
    }
}
