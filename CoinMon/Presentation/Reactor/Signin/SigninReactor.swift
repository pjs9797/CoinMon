import ReactorKit
import KakaoSDKUser
import RxKakaoSDKUser
import RxCocoa
import RxFlow

class SigninReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case setShowToastMessage(Bool)
        case kakaoLoginButtonTapped
        case coinMonLoginButtonTapped
        case signupButtonTapped
    }
    
    enum Mutation {
        case setShowToastMessage(Bool)
    }
    
    struct State {
        var showToastMessage: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setShowToastMessage(let show):
            return .just(.setShowToastMessage(show))
        case .kakaoLoginButtonTapped:
            self.kakaoLogin()
            return .empty()
        case .coinMonLoginButtonTapped:
            self.steps.accept(AppStep.goToSigninFlow)
            return .empty()
        case .signupButtonTapped:
            self.steps.accept(AppStep.goToSignupFlow)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setShowToastMessage(let show):
            newState.showToastMessage = show
        }
        return newState
    }
    
    private func kakaoLogin(){
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ (oauthToken) in
                    print("loginWithKakaoTalk() success.")
                    let oauthToken = oauthToken
                    print(oauthToken)
                }, onError: {error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
        else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext:{ (oauthToken) in
                    print("loginWithKakaoAccount() success.")
                    let oauthToken = oauthToken
                    print(oauthToken)
                }, onError: {error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
}
