import ReactorKit
import RxCocoa
import RxFlow

class PhoneVerificationNumberReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
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
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SignupStep.popViewController)
            return .empty()
        case .nextButtonTapped:
            self.steps.accept(SignupStep.navigateToSignupCompletedViewController)
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
            return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .take(while: { _ in self.currentState.remainingSeconds > 0 })
                .map { _ in .setTimer(self.currentState.remainingSeconds - 1) }
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
