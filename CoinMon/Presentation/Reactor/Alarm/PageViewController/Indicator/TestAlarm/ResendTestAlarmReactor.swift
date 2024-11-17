import ReactorKit
import RxCocoa
import RxFlow

class ResendTestAlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
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
            //TODO: 테스트 알람 API 호출
            self.steps.accept(AlarmStep.presentToIsReceivedTestAlarmViewController)
            return .empty()
        }
    }
}
