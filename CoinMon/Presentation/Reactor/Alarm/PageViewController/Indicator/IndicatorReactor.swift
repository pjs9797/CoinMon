import ReactorKit
import RxCocoa
import RxFlow

class IndicatorReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case addIndicatorButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addIndicatorButtonTapped:
            self.steps.accept(AlarmStep.navigateToSelectIndicatorViewController)
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
