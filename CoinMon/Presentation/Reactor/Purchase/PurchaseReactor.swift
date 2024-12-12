import ReactorKit
import RxCocoa
import RxFlow

class PurchaseReactor: ReactorKit.Reactor, Stepper {
    let disposeBag = DisposeBag()
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let purchaseUseCase: PurchaseUseCase
    
    init(purchaseUseCase: PurchaseUseCase) {
        self.purchaseUseCase = purchaseUseCase
        self.action.onNext(.loadSubscriptionStatus)
        PurchaseManager.shared.purchaseEvent
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .purchaseFailed:
                    self?.steps.accept(PurchaseStep.presentToFailurePurchaseAlertController)
                    
                case .verificationFailed:
                    self?.steps.accept(PurchaseStep.presentToServerFailurePurchaseAlertController)
                    
                case .verificationSuccess:
                    self?.steps.accept(PurchaseStep.navigateToSuccessSubscriptionViewController)
                    
                case .loadingFinished:
                    self?.action.onNext(.loadingFinished)
                }
            })
            .disposed(by: disposeBag)
    }
    
    enum Action {
        case loadingFinished
        case backButtonTapped
        case trialButtonTapped
        case loadSubscriptionStatus
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setSubscriptionStatus(UserSubscriptionStatus)
    }
    
    struct State {
        var isLoading: Bool = false
        var trialYN: String = "N"
        var subscriptionStatus: UserSubscriptionStatus = UserSubscriptionStatus(user: "", productId: nil, purchaseDate: nil, expiresDate: nil, isTrialPeriod: nil, autoRenewStatus: nil, status: .normal, useTrialYN: "N")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadingFinished:
            return .just(.setLoading(false))
        case .backButtonTapped:
            self.steps.accept(PurchaseStep.popWithCustomAnimation)
            return .empty()
        case .trialButtonTapped:
            PurchaseManager.shared.purchaseProduction()
            return .just(.setLoading(true))
        case .loadSubscriptionStatus:
            return purchaseUseCase.fetchSubscriptionStatus()
                .flatMap { subscriptionStatus -> Observable<Mutation> in
                    return .just(.setSubscriptionStatus(subscriptionStatus))
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        case .setSubscriptionStatus(let subscriptionStatus):
            newState.subscriptionStatus = subscriptionStatus
        }
        return newState
    }
}
