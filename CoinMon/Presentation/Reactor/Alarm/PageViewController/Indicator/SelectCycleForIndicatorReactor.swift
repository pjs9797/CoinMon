import ReactorKit
import RxCocoa
import RxFlow

class SelectCycleForIndicatorReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    
    init(indicatorUseCase: IndicatorUseCase, indicatorId: String, frequency: String, targets: [String], indicatorName: String, isPremium: Bool) {
        self.initialState = State(indicatorId: indicatorId, frequency: frequency, targets: targets, indicatorName: indicatorName, isPremium: isPremium)
        self.indicatorUseCase = indicatorUseCase
    }
    
    enum Action {
        case backButtonTapped
        case completeButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
        var indicatorId: String
        var frequency: String
        var targets: [String]
        var indicatorName: String
        var isPremium: Bool
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .completeButtonTapped:
            return self.indicatorUseCase.createIndicatorPush(indicatorId: currentState.indicatorId, frequency: currentState.frequency, targets: currentState.targets)
                .flatMap { resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
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
