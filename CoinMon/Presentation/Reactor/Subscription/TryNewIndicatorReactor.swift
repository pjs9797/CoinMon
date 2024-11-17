import ReactorKit
import RxCocoa
import RxFlow

class TryNewIndicatorReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case backButtonTapped
        case explainIndicatorButtonTapped
        case trialButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(TabBarStep.popDownWithAnimation)
            return .empty()
        case .explainIndicatorButtonTapped:
            self.steps.accept(TabBarStep.presentToExplainIndicatorSheetPresentationController(indicatorId: "1"))
            return .empty()
        case .trialButtonTapped:
            self.steps.accept(TabBarStep.goToPurchaseFlow)
            return .empty()
        }
    }
}
