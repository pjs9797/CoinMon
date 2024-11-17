import ReactorKit
import RxCocoa
import RxFlow

class IsNotSetTestAlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case laterButtonTapped
        case setAlarmButtonTapped
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
        case .setAlarmButtonTapped:
            self.steps.accept(AlarmStep.goToAlarmSetting)
            return .empty()
        }
    }
}
