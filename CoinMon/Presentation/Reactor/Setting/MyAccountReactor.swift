import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class MyAccountReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase){
        self.userUseCase = userUseCase
    }
    
    enum Action {
        case loadUserData
        case backButtonTapped
        case updateNickname(String)
        case changeNicknameButtonTapped
        case logoutButtonTapped
        case logoutAlertYesButtonTapped
        case withdrawalButtonTapped
    }
    
    enum Mutation {
        case setImageIndex(String)
        case setNickname(String)
        case setNicknameErrorLabelHidden
        case setLoginType(String)
        case setEmail(String)
    }
    
    struct State {
        var imageIndex: String = "1"
        var nickname: String = ""
        var nicknameErrorLabelHidden: Bool = true
        var loginType: String = "COINMON"
        var email: String = ""
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadUserData:
            return userUseCase.fetchUserData()
                .flatMap { data -> Observable<Mutation> in
                    return .concat([
                        .just(.setImageIndex(data.imgIndex)),
                        .just(.setNickname(data.nickname)),
                        .just(.setLoginType(data.userType ?? "COINMON")),
                        .just(.setEmail(data.email))
                    ])
                }
                .catch { [weak self] _ in
                    self?.steps.accept(SettingStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .backButtonTapped:
            self.steps.accept(SettingStep.popViewController)
            return .empty()
        case .updateNickname(let nickname):
            return .just(.setNickname(nickname))
        case .changeNicknameButtonTapped:
            if currentState.nicknameErrorLabelHidden {
                return .just(.setNicknameErrorLabelHidden)
            }
            else {
                return userUseCase.changeNickname(nickname: currentState.nickname)
                    .flatMap { [weak self] resultCode -> Observable<Mutation> in
                        if resultCode == "200" {
                            return .just(.setNicknameErrorLabelHidden)
                        }
                        else {
                            self?.steps.accept(SettingStep.presentToDuplicatedNicknameErrorAlertController)
                            return .empty()
                        }
                    }
                    .catch { [weak self] _ in
                        self?.steps.accept(SettingStep.presentToNetworkErrorAlertController)
                        return .empty()
                    }
            }
        case .logoutButtonTapped:
            self.steps.accept(SettingStep.presentToLogoutAlertController(reactor: self))
            return .empty()
        case .logoutAlertYesButtonTapped:
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            self.steps.accept(SettingStep.completeMainFlow)
            return .empty()
        case .withdrawalButtonTapped:
            self.steps.accept(SettingStep.navigateToWithdrawalViewController)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setImageIndex(let index):
            newState.imageIndex = index
        case .setNickname(let nickname):
            newState.nickname = nickname
        case .setNicknameErrorLabelHidden:
            newState.nicknameErrorLabelHidden = !currentState.nicknameErrorLabelHidden
        case .setLoginType(let type):
            newState.loginType = type
        case .setEmail(let email):
            newState.email = email
        }
        return newState
    }
}
