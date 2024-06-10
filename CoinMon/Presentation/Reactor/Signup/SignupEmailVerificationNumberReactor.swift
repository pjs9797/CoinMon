import ReactorKit
import RxCocoa
import RxFlow

class SignupEmailVerificationNumberReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    var timerDisposeBag = DisposeBag()
    private let signupUseCase: SignupUseCase
    
    init(signupUseCase: SignupUseCase){
        self.signupUseCase = signupUseCase
    }
    
    enum Action {
        case postEmailCode
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
        var nextButtonTitle: String = LocalizationManager.shared.localizedString(forKey: "다음")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .postEmailCode:
            return signupUseCase.requestEmailVerificationCode(email: UserCredentialsManager.shared.email)
                .flatMap { resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                    }
                    else {
                    }
                    return .empty()
                }
                .catch { [weak self] _ in
                    self?.steps.accept(SignupStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .backButtonTapped:
            self.steps.accept(SignupStep.popViewController)
            return .empty()
        case .nextButtonTapped:
            return signupUseCase.checkEmailVerificationCode(email: UserCredentialsManager.shared.email, number: currentState.verificationNumber)
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        self?.steps.accept(SignupStep.navigateToSignupPhoneNumberEntryViewController)
                    }
                    else {
                        self?.steps.accept(SignupStep.presentToAuthenticationNumberErrorAlertController)
                    }
                    return .empty()
                }
                .catch { [weak self] _ in
                    self?.steps.accept(SignupStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
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
