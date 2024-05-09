import ReactorKit
import RxCocoa
import RxFlow

class SignupCompletedReactor: ReactorKit.Reactor, Stepper {    
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    typealias Mutation = NoMutation
    
    enum Action {
        case signupCompletedButtonTapped
    }
    
    struct State {}
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .signupCompletedButtonTapped:
            self.steps.accept(SignupStep.completeSignupFlow)
            return .empty()
        }
    }
}
