import ReactorKit
import RxCocoa
import RxFlow

class TermsOfServiceReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case selectAllButtonTapped
        case firstCheckButtonTapped
        case secondCheckButtonTapped
        case thirdCheckButtonTapped
        case firstTermsOfServiceDetailButtonTapped
        case secondTermsOfServiceDetailButtonTapped
        case thirdTermsOfServiceDetailButtonTapped
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
        case .firstTermsOfServiceDetailButtonTapped:
            //TODO: 약관 나오면 약관 상세 페이지 연결
            return .empty()
        case .secondTermsOfServiceDetailButtonTapped:
            //TODO: 약관 나오면 약관 상세 페이지 연결
            return .empty()
        case .thirdTermsOfServiceDetailButtonTapped:
            //TODO: 약관 나오면 약관 상세 페이지 연결
            return .empty()
        case .nextButtonTapped:
            self.steps.accept(SignupStep.navigateToVerificationNumberViewController)
            return .empty()
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
