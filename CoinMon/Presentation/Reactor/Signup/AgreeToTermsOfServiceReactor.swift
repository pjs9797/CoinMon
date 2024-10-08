import ReactorKit
import RxCocoa
import RxFlow

class AgreeToTermsOfServiceReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let signupUseCase: SignupUseCase
    
    init(signupUseCase: SignupUseCase){
        self.signupUseCase = signupUseCase
    }
    
    enum Action {
        case selectAllButtonTapped
        case firstCheckButtonTapped
        case secondCheckButtonTapped
        case thirdCheckButtonTapped
        case termsOfServiceDetailButtonTapped
        case privacyPolicyDetailButtonTapped
        case marketingConsentDetailButtonTapped
        case nextButtonTapped
    }
    
    enum Mutation {
        case toggleAllChecks(Bool)
        case toggleFirstCheck
        case toggleSecondCheck
        case toggleThirdCheck
        case setNextButtonValid
    }
    
    struct State {
        var isSelectAllButtonChecked: Bool = false
        var isFirstCheckButtonChecked: Bool = false
        var isSecondCheckButtonChecked: Bool = false
        var isThirdCheckButtonChecked: Bool = false
        var isNextButtonValid: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectAllButtonTapped:
            let allChecked = !currentState.isSelectAllButtonChecked
            return Observable<Mutation>.from([
                .toggleAllChecks(allChecked),
                .setNextButtonValid
            ])
        case .firstCheckButtonTapped:
            return Observable<Mutation>.from([
                .toggleFirstCheck,
                .setNextButtonValid
            ])
        case .secondCheckButtonTapped:
            return Observable<Mutation>.from([
                .toggleSecondCheck,
                .setNextButtonValid
            ])
        case .thirdCheckButtonTapped:
            return Observable<Mutation>.from([
                .toggleThirdCheck,
                .setNextButtonValid
            ])
        case .termsOfServiceDetailButtonTapped:
            self.steps.accept(SignupStep.dismissViewController)
            self.steps.accept(SignupStep.navigateToTermsOfServiceViewController)
            return .empty()
        case .privacyPolicyDetailButtonTapped:
            self.steps.accept(SignupStep.dismissViewController)
            self.steps.accept(SignupStep.navigateToTermsOfServiceViewController)
            return .empty()
        case .marketingConsentDetailButtonTapped:
            self.steps.accept(SignupStep.dismissViewController)
            self.steps.accept(SignupStep.navigateToTermsOfServiceViewController)
            return .empty()
        case .nextButtonTapped:
            return signupUseCase.requestPhoneVerificationCode(phoneNumber: UserCredentialsManager.shared.phoneNumber)
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        self?.steps.accept(SignupStep.dismissViewController)
                        self?.steps.accept(SignupStep.navigateToPhoneVerificationNumberViewController)
                    }
                    else {
                        self?.steps.accept(SignupStep.presentToAlreadysubscribedNumberErrorAlertController)
                    }
                    return .empty()
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: SignupStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .toggleAllChecks(let allChecked):
            newState.isSelectAllButtonChecked = allChecked
            newState.isFirstCheckButtonChecked = allChecked
            newState.isSecondCheckButtonChecked = allChecked
            newState.isThirdCheckButtonChecked = allChecked
        case .toggleFirstCheck:
            newState.isFirstCheckButtonChecked = !newState.isFirstCheckButtonChecked
        case .toggleSecondCheck:
            newState.isSecondCheckButtonChecked = !newState.isSecondCheckButtonChecked
        case .toggleThirdCheck:
            newState.isThirdCheckButtonChecked = !newState.isThirdCheckButtonChecked
        case .setNextButtonValid:
            newState.isNextButtonValid = newState.isFirstCheckButtonChecked && newState.isSecondCheckButtonChecked
        }
        newState.isSelectAllButtonChecked = newState.isFirstCheckButtonChecked && newState.isSecondCheckButtonChecked && newState.isThirdCheckButtonChecked
        return newState
    }
}
