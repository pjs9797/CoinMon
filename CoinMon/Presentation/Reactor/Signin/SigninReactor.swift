import ReactorKit
import KakaoSDKUser
import RxKakaoSDKUser
import RxCocoa
import RxFlow

class SigninReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    
    init() {
        self.initialState = State(currentLanguage: LocalizationManager.shared.language)
    }
    
    enum Action {
        case setShowToastMessage(Bool)
        case kakaoLoginButtonTapped
        case coinMonLoginButtonTapped
        case signupButtonTapped
        case languageSettingButtonTapped
        case setLanguage(String)
    }
    
    enum Mutation {
        case setShowToastMessage(Bool)
        case setLanguage(String)
    }
    
    struct State {
        var showToastMessage: Bool = false
        var currentLanguage: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setShowToastMessage(let show):
            return .just(.setShowToastMessage(show))
        case .kakaoLoginButtonTapped:
            //self.kakaoLogin()
            self.purchaseProduction()
            return .empty()
        case .coinMonLoginButtonTapped:
            self.steps.accept(AppStep.goToSigninFlow)
            return .empty()
        case .signupButtonTapped:
            self.steps.accept(AppStep.goToSignupFlow)
            return .empty()
        case .languageSettingButtonTapped:
            self.steps.accept(AppStep.presentToLanguageSettingAlertController(reactor: self))
            return .empty()
        case .setLanguage(let newLanguage):
            LocalizationManager.shared.setLanguage(newLanguage)
            return .just(.setLanguage(newLanguage))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setShowToastMessage(let show):
            newState.showToastMessage = show
        case .setLanguage(let newLanguage):
            newState.currentLanguage = newLanguage
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
    
    private func purchaseProduction(){
        guard let product = PurchaseManager.shared.products.first else {
            print("Product is not available.")
            return
        }
        
        // 구매 처리
        Task {
            do {
                try await PurchaseManager.shared.purchase(product)
            } catch {
                print("Purchase failed: \(error.localizedDescription)")
            }
        }
    }
}
