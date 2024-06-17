import ReactorKit
import RxCocoa
import RxFlow

class SettingReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    
    init() {
        self.initialState = State(currentLanguage: LocalizationManager.shared.language)
    }
    
    enum Action {
        case changeLanguage(String)
        case alarmSettingButtonTapped
        case myAccountButtonTapped
        case inquiryButtonTapped
        case termsOfServiceButtonTapped
        case privacyPolicyButtonTapped
    }
    
    enum Mutation {
        case setLanguage(String)
    }
    
    struct State {
        var currentLanguage: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeLanguage(let newLanguage):
            LocalizationManager.shared.setLanguage(newLanguage)
            return Observable.just(.setLanguage(newLanguage))
        case .alarmSettingButtonTapped:
            self.steps.accept(SettingStep.goToAlarmSetting)
            return .empty()
        case .myAccountButtonTapped:
            self.steps.accept(SettingStep.navigateToMyAccountViewController)
            return .empty()
        case .inquiryButtonTapped:
            self.steps.accept(SettingStep.navigateToInquiryViewController)
            return .empty()
        case .termsOfServiceButtonTapped:
            self.steps.accept(SettingStep.navigateToTermsOfServiceViewController)
            return .empty()
        case .privacyPolicyButtonTapped:
            self.steps.accept(SettingStep.navigateToPrivacyPolicyViewController)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLanguage(let newLanguage):
            newState.currentLanguage = newLanguage
        }
        return newState
    }
}
