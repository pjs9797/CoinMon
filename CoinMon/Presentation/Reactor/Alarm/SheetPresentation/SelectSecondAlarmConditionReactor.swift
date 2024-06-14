import ReactorKit
import RxCocoa
import RxFlow

class SelectSecondAlarmConditionReactor: ReactorKit.Reactor,Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    var secondAlarmConditionRelay: PublishRelay<String>
    
    init(secondAlarmConditionRelay: PublishRelay<String>){
        self.secondAlarmConditionRelay = secondAlarmConditionRelay
    }
    
    enum Action {
        case selectCondition(Int)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var conditions: [String] = [
            LocalizationManager.shared.localizedString(forKey: "한 번만"),
            LocalizationManager.shared.localizedString(forKey: "1분 간격"),
            LocalizationManager.shared.localizedString(forKey: "5분 간격"),
            LocalizationManager.shared.localizedString(forKey: "10분 간격"),
            LocalizationManager.shared.localizedString(forKey: "30분 간격"),
            LocalizationManager.shared.localizedString(forKey: "1시간 간격"),
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectCondition(let index):
            secondAlarmConditionRelay.accept(currentState.conditions[index])
            self.steps.accept(AlarmStep.dismissSheetPresentationController)
            return .empty()
        }
    }
}
