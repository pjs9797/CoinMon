import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class SignupEmailEntryReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let signupUseCase: SignupUseCase
    
    init(signupUseCase: SignupUseCase){
        self.signupUseCase = signupUseCase
    }
    
    enum Action {
        case backButtonTapped
        case nextButtonTapped
        case duplicateButtonTapped
        case updateEmail(String)
    }
    
    enum Mutation {
        case setEmail(String)
        case setDuplicateButtonEnable(Bool)
        case setEmailDuplicate(Bool?)
    }
    
    struct State {
        var email: String = ""
        var isEmailValid: Bool = false
        var isDuplicatedEmail: Bool? = nil
        var isNextButtonEnable: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SignupStep.popToRootViewController)
            return .empty()
        case .nextButtonTapped:
            UserCredentialsManager.shared.email = currentState.email
            self.steps.accept(SignupStep.navigateToSignupEmailVerificationNumberViewController)
            return .empty()
        case .duplicateButtonTapped:
            return signupUseCase.checkEmailDuplication(email: currentState.email)
                .flatMap { resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        return .just(.setEmailDuplicate(false))
                    }
                    else {
                        return .just(.setEmailDuplicate(true))
                    }
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: SignupStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .updateEmail(let email):
            let isValid = isValidEmail(email)
            if isValid {
                return .concat([
                    .just(.setEmail(email)),
                    .just(.setDuplicateButtonEnable(isValid)),
                ])
            }
            else{
                return .concat([
                    .just(.setEmail(email)),
                    .just(.setDuplicateButtonEnable(isValid)),
                    .just(.setEmailDuplicate(nil))
                ])
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEmail(let email):
            newState.email = email
        case .setDuplicateButtonEnable(let isValid):
            newState.isEmailValid = isValid
        case .setEmailDuplicate(let isDuplicated):
            newState.isDuplicatedEmail = isDuplicated
            newState.isNextButtonEnable = !(isDuplicated ?? false) && state.isEmailValid
        }
        return newState
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
