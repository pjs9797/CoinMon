import ReactorKit
import RxCocoa
import RxFlow

class WithdrawalReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase){
        self.userUseCase = userUseCase
    }
    
    enum Action {
        case withdrawAlertYesButtonTapped
        case backButtonTapped
        case checkButtonTapped
    }
    
    enum Mutation {
        case setChecked
    }
    
    struct State {
        var isChecked: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .withdrawAlertYesButtonTapped:
            return userUseCase.withdraw()
                .flatMap { [weak self] _ -> Observable<Mutation> in
                    self?.steps.accept(SettingStep.completeMainFlow)
                    return .empty()
                }
                .catch { [weak self] _ in
                    self?.steps.accept(SettingStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .backButtonTapped:
            self.steps.accept(SettingStep.popViewController)
            return .empty()
        case .checkButtonTapped:
            return .just(.setChecked)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setChecked:
            newState.isChecked = !newState.isChecked
        }
        return newState
    }
}
