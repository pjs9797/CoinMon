import ReactorKit
import RxCocoa
import RxFlow

class NewIndicatorReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case trialButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .trialButtonTapped:
            self.steps.accept(TabBarStep.dismiss)
            self.steps.accept(TabBarStep.navigateToTryNewIndicatorViewController)
            return .empty()
        }
    }
}
