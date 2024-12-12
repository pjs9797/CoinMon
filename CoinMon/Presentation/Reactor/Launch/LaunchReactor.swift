import ReactorKit
import RxCocoa
import RxFlow

class LaunchReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let userUseCase = UserUseCase(repository: UserRepository())
    
    enum Action {
        case checkRefreshToken
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkRefreshToken:
            if UserDefaultsManager.shared.getIsFirstLaunch() {
                self.steps.accept(AppStep.navigateToSurveyViewController)
                return .empty()
            }
            else {
                return userUseCase.checkRefresh()
                    .flatMap { [weak self] resultCode -> Observable<Mutation> in
                        if resultCode == "200" {
                            self?.steps.accept(AppStep.navigateToTabBarController)
                        }
                        else {
                            print("checkRefresh Error: ",resultCode)
                            self?.steps.accept(AppStep.navigateToSigninViewController)
                        }
                        return .empty()
                    }
                    .catch { [weak self] error in
                        print("checkRefresh Error: ",error.localizedDescription)
                        self?.steps.accept(AppStep.navigateToSigninViewController)
                        return .empty()
                    }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}
