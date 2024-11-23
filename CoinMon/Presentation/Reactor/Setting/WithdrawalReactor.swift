import Foundation
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
        case withdrawAlertOkButtonTapped
        case backButtonTapped
        case checkButtonTapped
        case withdrawAlertButtonTapped
    }
    
    enum Mutation {
        case setChecked
    }
    
    struct State {
        var isChecked: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(SettingStep.popViewController)
            return .empty()
        case .checkButtonTapped:
            return .just(.setChecked)
        case .withdrawAlertButtonTapped:
            self.steps.accept(SettingStep.presentToWithdrawAlertController(reactor: self))
            return .empty()
        case .withdrawAlertOkButtonTapped:
            let loginType = UserDefaultsManager.shared.getLoginType()
            switch loginType {
            case .coinmon:
                return userUseCase.withdraw()
                    .flatMap { [weak self] _ -> Observable<Mutation> in
                        self?.steps.accept(SettingStep.endFlowAfterWithdrawal)
                        return .empty()
                    }
                    .catch { [weak self] error in
                        ErrorHandler.handle(error) { (step: SettingStep) in
                            self?.steps.accept(step)
                        }
                        return .empty()
                    }
                
            case .apple:
                return .empty()
            case .kakao:
                return .empty()
            case .none:
                return .empty()
            }
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

