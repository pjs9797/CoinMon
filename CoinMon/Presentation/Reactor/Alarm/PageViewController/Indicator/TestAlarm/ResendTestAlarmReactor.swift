import ReactorKit
import RxCocoa
import RxFlow

class ResendTestAlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    
    init(indicatorUseCase: IndicatorUseCase) {
        self.indicatorUseCase = indicatorUseCase
    }
    
    enum Action {
        case laterButtonTapped
        case receiveButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .laterButtonTapped:
            self.steps.accept(AlarmStep.dismissSheetPresentationController)
            return .empty()
        case .receiveButtonTapped:
            self.steps.accept(AlarmStep.dismissSheetPresentationController)
            return indicatorUseCase.testPush()
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        self?.steps.accept(AlarmStep.presentToIsReceivedTestAlarmViewController)
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
}
