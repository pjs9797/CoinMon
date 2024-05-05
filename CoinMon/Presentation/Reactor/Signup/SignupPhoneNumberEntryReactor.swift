import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class SignupPhoneNumberEntryReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case backButtonTapped
        case nextButtonTapped
        case clearButtonTapped
        case updatePhoneNumber(String)
    }
    
    enum Mutation {
        case setPhoneNumber(String)
        case setClearButtonHidden(Bool)
        case setValid(Bool)
    }
    
    struct State {
        var phoneNumber: String = ""
        var isPhoneNumberValid: Bool = false
        var isClearButtonHidden: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SignupStep.popViewController)
            return .empty()
        case .nextButtonTapped:
            
            return .empty()
        case .clearButtonTapped:
            return .concat([
                .just(.setPhoneNumber("")),
                .just(.setClearButtonHidden(true)),
                .just(.setValid(false))
            ])
        case .updatePhoneNumber(let phoneNumber):
            let isPhoneNumberValid = phoneNumber.count == 10 || phoneNumber.count == 11
            return .concat([
                .just(.setPhoneNumber(phoneNumber)),
                .just(.setClearButtonHidden(phoneNumber.isEmpty)),
                .just(.setValid(isPhoneNumberValid))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setPhoneNumber(let phoneNumber):
            newState.phoneNumber = phoneNumber
        case .setClearButtonHidden(let isHidden):
            newState.isClearButtonHidden = isHidden
        case .setValid(let isValid):
            newState.isPhoneNumberValid = isValid
        }
        return newState
    }
}
