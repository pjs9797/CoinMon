import ReactorKit
import RxCocoa
import RxFlow

class EmailVerificationNumberReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    var timerDisposeBag = DisposeBag()
    let emailFlow: EmailFlow
    
    init(emailFlow: EmailFlow) {
        self.emailFlow = emailFlow
        initialState = State(nextButtonTitle: emailFlow == .signin ? LocalizationManager.shared.localizedString(forKey: "완료") : LocalizationManager.shared.localizedString(forKey: "다음"))
    }
    
    enum Action {
        case backButtonTapped
        case nextButtonTapped
        case clearButtonTapped
        case startTimer
        case updateVerificationNumber(String)
    }
    
    enum Mutation {
        case setVerificationNumber(String)
        case setTimer(Int)
        case setClearButtonHidden(Bool)
        case setValid(Bool)
    }
    
    struct State {
        var verificationNumber: String = ""
        var remainingSeconds: Int = 180
        var isVerificationNumberValid: Bool = false
        var isClearButtonHidden: Bool = false
        var nextButtonTitle: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            switch emailFlow {
            case .signup:
                self.steps.accept(SignupStep.popViewController)
            case .signin:
                self.steps.accept(SigninStep.popViewController)
            }
            return .empty()
        case .nextButtonTapped:
            switch emailFlow {
            case .signup:
                self.steps.accept(SignupStep.navigateToSignupPhoneNumberEntryViewController)
            case .signin:
                self.steps.accept(SigninStep.completeSigninFlow)
            }
            return .empty()
        case .clearButtonTapped:
            return .concat([
                .just(.setVerificationNumber("")),
                .just(.setClearButtonHidden(true)),
                .just(.setValid(false))
            ])
        case .updateVerificationNumber(let verificationNumber):
            let isverificationNumberValid = verificationNumber.count == 6
            return .concat([
                .just(.setVerificationNumber(verificationNumber)),
                .just(.setClearButtonHidden(verificationNumber.isEmpty)),
                .just(.setValid(isverificationNumberValid))
            ])
        case .startTimer:
            timerDisposeBag = DisposeBag()
            return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .take(while: { [weak self] _ in self?.currentState.remainingSeconds ?? 0 > 0 })
                .map { [weak self] _ in .setTimer((self?.currentState.remainingSeconds ?? 1) - 1) }
                .do(onDispose: { [weak self] in
                    self?.timerDisposeBag = DisposeBag()
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setVerificationNumber(let verificationNumber):
            newState.verificationNumber = verificationNumber
        case .setClearButtonHidden(let isHidden):
            newState.isClearButtonHidden = isHidden
        case .setValid(let isValid):
            newState.isVerificationNumberValid = isValid
        case .setTimer(let seconds):
            newState.remainingSeconds = seconds
        }
        return newState
    }
}
