import ReactorKit
import RxCocoa
import RxFlow

class PrivacyPolicyReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let flowType: FlowType
    
    init(flowType: FlowType){
        self.flowType = flowType
    }
    
    enum Action {
        case backButtonTapped
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            switch flowType{
            case .signup:
                self.steps.accept(SignupStep.popViewController)
            case .setting:
                self.steps.accept(SettingStep.popViewController)
            default:
                return .empty()
            }
            return .empty()
        }
    }
}
