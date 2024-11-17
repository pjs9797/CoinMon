import ReactorKit
import RxCocoa
import RxFlow

class SelectIndicatorReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    private let purchaseUseCase: PurchaseUseCase
    
    init(indicatorUseCase: IndicatorUseCase, purchaseUseCase: PurchaseUseCase) {
        self.indicatorUseCase = indicatorUseCase
        self.purchaseUseCase = purchaseUseCase
    }
    
    enum Action {
        case backButtonTapped
        case explainButtonTapped(indicatorId: String)
        case rightButtonTapped(isPushed: Bool, indicatorId: String, indicatorName: String, isPremium: Bool)
        case alarmButtonTapped(indicatorId: String, indicatorName: String)
        case trialButtonTapped
        case selectCategory(Int)
        case loadSubscriptionStatus
    }
    
    enum Mutation {
        case setIndicators([IndicatorInfo])
        case setSelectedCategory(Int)
        case setSubscriptionStatus(UserSubscriptionStatus)
    }
    
    struct State {
        var selectedCategory: Int = 0
        var categories: [String] = [
            LocalizationManager.shared.localizedString(forKey: "전체"),
            LocalizationManager.shared.localizedString(forKey: "프리미엄"),
            LocalizationManager.shared.localizedString(forKey: "무료")
        ]
        var indicators: [IndicatorInfo] = []
        var subscriptionStatus: UserSubscriptionStatus = UserSubscriptionStatus(user: "", productId: nil, purchaseDate: nil, expiresDate: nil, isTrialPeriod: nil, autoRenewStatus: nil, status: .normal, useTrialYN: "N")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .explainButtonTapped(let indicatorId):
            //TODO: 플로우 타입으로 나눠서
            self.steps.accept(AlarmStep.presentToExplainIndicatorSheetPresentationController(indicatorId: indicatorId))
            return .empty()
        case .rightButtonTapped(let isPushed, let indicatorId, let indicatorName, let isPremium):
            if isPushed {
                self.steps.accept(AlarmStep.navigateToDetailIndicatorViewController(flowType: "WhenNotCreate", indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium, frequency: "15"))
            }
            else {
                self.steps.accept(AlarmStep.navigateToSelectCoinForIndicatorViewController(flowType: .atNotPurchase, indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium))
            }
            return .empty()
        case .alarmButtonTapped(let indicatorId, let indicatorName):
            self.steps.accept(AlarmStep.presentToDeleteIndicatorPushSheetPresentationController(indicatorId: indicatorId, indicatorName: indicatorName, flowType: "DeleteAtSelectIndicator"))
            return .empty()
        case .trialButtonTapped:
            self.steps.accept(AlarmStep.goToPurchaseFlow)
            return .empty()
        case .selectCategory(let index):
            return indicatorUseCase.getIndicatorInfo(language: LocalizationManager.shared.language, categoryIndex: index)
                .flatMap { indicatorInfo -> Observable<Mutation> in
                    
                    return .concat([
                        .just(.setIndicators(indicatorInfo)),
                        .just(.setSelectedCategory(index))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
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
        case .setIndicators(let indicators):
            newState.indicators = indicators
        case .setSelectedCategory(let index):
            newState.selectedCategory = index
        case .setSubscriptionStatus(let subscriptionStatus):
            newState.subscriptionStatus = subscriptionStatus
        }
        return newState
    }
}
