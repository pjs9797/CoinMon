import ReactorKit
import RxCocoa
import RxFlow

class SelectFirstAlarmConditionReactor: ReactorKit.Reactor,Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    var firstAlarmConditionRelay: PublishRelay<Int>
    
    init(firstAlarmConditionRelay: PublishRelay<Int>){
        self.firstAlarmConditionRelay = firstAlarmConditionRelay
    }
    
    enum Action {
        case selectCondition(Int)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var conditions: [Int] = [-10,-9,-8,-7,-6,-5,-4,-3,0,3,4,5,6,7,8,9,10]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectCondition(let index):
            firstAlarmConditionRelay.accept(currentState.conditions[index])
            self.steps.accept(AlarmStep.dismissSheetPresentationController)
            return .empty()
        }
    }
}
