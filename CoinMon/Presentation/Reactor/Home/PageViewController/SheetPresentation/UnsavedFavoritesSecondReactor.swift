import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class UnsavedFavoritesSecondReactor: ReactorKit.Reactor,Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case continueButtonTapped
        case moveButtonTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .continueButtonTapped:
            NotificationCenter.default.post(name: .marketStayed, object: nil)
            self.steps.accept(HomeStep.dismiss)
            return .empty()
        case .moveButtonTapped:
            NotificationCenter.default.post(name: .marketSelected, object: nil)
            self.steps.accept(HomeStep.dismiss)
            return .empty()
        }
    }
}
