import ReactorKit
import RxCocoa
import RxFlow

class MarketingConsentReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let termsOfServiceFlow: TermsOfServiceFlow
    
    init(termsOfServiceFlow: TermsOfServiceFlow){
        self.termsOfServiceFlow = termsOfServiceFlow
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
            switch termsOfServiceFlow{
            case .signup:
                self.steps.accept(SignupStep.popViewController)
            case .setting:
                self.steps.accept(SettingStep.popViewController)
            }
            return .empty()
        }
    }
}
