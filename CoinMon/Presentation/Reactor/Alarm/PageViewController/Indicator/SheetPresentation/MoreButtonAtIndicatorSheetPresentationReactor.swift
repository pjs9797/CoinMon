import ReactorKit
import RxCocoa
import RxFlow

class MoreButtonAtIndicatorSheetPresentationReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    
    init(indicatorUseCase: IndicatorUseCase, indicatorId: String, indicatorName: String, frequency: String) {
        self.initialState = State(indicatorId: indicatorId, indicatorName: indicatorName, frequency: frequency)
        self.indicatorUseCase = indicatorUseCase
    }
    
    enum Action {
        case updateButtonTapped
        case deleteButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
        var indicatorId: String
        var indicatorName: String
        var frequency: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateButtonTapped:
            self.steps.accept(AlarmStep.dismissSheetPresentationController)
            self.steps.accept(AlarmStep.navigateToUpdateIndicatorCoinViewController(indicatorId: currentState.indicatorId, indicatorName: currentState.indicatorName, frequency: currentState.indicatorName))
            return .empty()
        case .deleteButtonTapped:
            return indicatorUseCase.deleteIndicatorPush(indicatorId: currentState.indicatorId)
                .flatMap { resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        self.steps.accept(AlarmStep.dismissSheetPresentationController)
                        self.steps.accept(AlarmStep.popToRootViewController)
                    }
                    return .empty()
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}
