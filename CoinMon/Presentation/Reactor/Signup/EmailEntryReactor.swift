import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class EmailEntryReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case backButtonTapped
        case nextButtonTapped
        case clearButtonTapped
        case updateEmail(String)
    }
    
    enum Mutation {
        case setEmail(String)
        case setClearButtonHidden(Bool)
        case setValid(Bool)
    }
    
    struct State {
        var email: String = ""
        var isEmailValid: Bool = false
        var isClearButtonHidden: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SignupStep.completeSignupFlow)
            return .empty()
        case .nextButtonTapped:
            UserCredentialsManager.shared.email = currentState.email
            self.steps.accept(SignupStep.navigateToSignupPhoneNumberEntryViewController)
            return .empty()
        case .clearButtonTapped:
            return .concat([
                .just(.setEmail("")),
                .just(.setClearButtonHidden(true)),
                .just(.setValid(false))
            ])
        case .updateEmail(let email):
            return .concat([
                .just(.setEmail(email)),
                .just(.setClearButtonHidden(email.isEmpty)),
                .just(.setValid(isValidEmail(email)))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setEmail(let email):
            newState.email = email
        case .setClearButtonHidden(let isHidden):
            newState.isClearButtonHidden = isHidden
        case .setValid(let isValid):
            newState.isEmailValid = isValid
        }
        return newState
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
