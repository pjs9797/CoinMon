import ReactorKit
import RxCocoa
import RxFlow

class UnsavedFavoritesReactor: ReactorKit.Reactor,Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case continueButtonTapped
        case finishButtonTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .continueButtonTapped:
            self.steps.accept(HomeStep.dismiss)
            return .empty()
        case .finishButtonTapped:
            self.steps.accept(HomeStep.dismissAndPopViewController)
            return .empty()
        }
    }
}
