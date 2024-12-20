import ReactorKit
import FirebaseMessaging
import RxCocoa
import RxFlow

class SigninEmailVerificationNumberReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    var timerDisposeBag = DisposeBag()
    private let signinUseCase: SigninUseCase
    
    init(signinUseCase: SigninUseCase){
        self.signinUseCase = signinUseCase
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
        var remainingSeconds: Int = 300
        var isVerificationNumberValid: Bool = false
        var isClearButtonHidden: Bool = false
        var nextButtonTitle: String = LocalizationManager.shared.localizedString(forKey: "완료")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .postEmailCode:
            return signinUseCase.requestEmailVerificationCode(email: UserCredentialsManager.shared.email)
                .flatMap { _ -> Observable<Mutation> in
                    return .empty()
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: SigninStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .backButtonTapped:
            self.steps.accept(SigninStep.popViewController)
            return .empty()
        case .nextButtonTapped:
            if let fcmToken = TokenManager.shared.loadFCMToken() {
                print("fcmToken", fcmToken)
                return signinUseCase.checkEmailVerificationCodeForLogin(email: UserCredentialsManager.shared.email, number: currentState.verificationNumber, deviceToken: fcmToken)
                    .flatMap { [weak self] resultCode -> Observable<Mutation> in
                        if resultCode == "200" {
                            self?.steps.accept(SigninStep.completeSigninFlow)
                        } else {
                            self?.steps.accept(SigninStep.presentToAuthenticationNumberErrorAlertController)
                        }
                        return .empty()
                    }
                    .catch { [weak self] error in
                        ErrorHandler.handle(error) { (step: SigninStep) in
                            self?.steps.accept(step)
                        }
                        return .empty()
                    }
            }
            else {
                print("FCM 토큰을 불러오지 못했습니다. 새로 갱신합니다.")
                Messaging.messaging().token { [weak self] token, error in
                    if let error = error {
                        print("FCM 토큰을 가져오는 중 에러 발생: \(error)")
                    }
                    else if let token = token {
                        print("새로운 FCM 토큰: \(token)")
                        TokenManager.shared.saveFCMToken(token)
                        // FCM 토큰을 얻은 후 로그인 시도
                        self?.signinUseCase.checkEmailVerificationCodeForLogin(email: UserCredentialsManager.shared.email, number: self?.currentState.verificationNumber ?? "000000", deviceToken: token)
                            .flatMap { [weak self] resultCode -> Observable<Mutation> in
                                if resultCode == "200" {
                                    self?.steps.accept(SigninStep.completeSigninFlow)
                                } else {
                                    self?.steps.accept(SigninStep.presentToAuthenticationNumberErrorAlertController)
                                }
                                return .empty()
                            }
                            .catch { [weak self] error in
                                ErrorHandler.handle(error) { (step: SigninStep) in
                                    self?.steps.accept(step)
                                }
                                return .empty()
                            }
                            .subscribe(onNext: { _ in
                                
                            }, onError: { error in
                                print("에러 발생: \(error)")
                            })
                            .disposed(by: DisposeBag())
                    }
                }
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
