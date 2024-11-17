import ReactorKit
import RxCocoa
import RxFlow
import Foundation

class DeleteIndicatorPushSheetPresentationReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    
    init(indicatorUseCase: IndicatorUseCase, indicatorId: String, indicatorName: String, flowType: String) {
        self.initialState = State(indicatorId: indicatorId, indicatorName: indicatorName, flowType: flowType)
        self.indicatorUseCase = indicatorUseCase
    }
    
    enum Action {
        case closeButtonTapped
        case deleteButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
        var indicatorId: String
        var indicatorName: String
        var flowType: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .closeButtonTapped:
            self.steps.accept(AlarmStep.dismissSheetPresentationController)
            return .empty()
        case .deleteButtonTapped:
            return indicatorUseCase.deleteIndicatorPush(indicatorId: currentState.indicatorId)
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        let indicatorName = self?.currentState.indicatorName
                        let message = LocalizationManager.shared.localizedString(forKey: "지표 알람을 삭제했어요", arguments: indicatorName!)
                        
                        NotificationCenter.default.post(name: .completeDeleteIndicatorAlarm, object: nil, userInfo: ["message": message])
                        if self?.currentState.flowType == "DeleteAtSelectIndicator" {
                            self?.steps.accept(AlarmStep.dismissSheetPresentationController)
                        }
                        else {
                            self?.steps.accept(AlarmStep.dismissSheetPresentationController)
                            self?.steps.accept(AlarmStep.popToRootViewController)
                        }
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
