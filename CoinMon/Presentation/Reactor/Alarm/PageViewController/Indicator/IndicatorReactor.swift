import ReactorKit
import RxCocoa
import RxFlow

class IndicatorReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    private let purchaseUseCase: PurchaseUseCase
    
    init(indicatorUseCase: IndicatorUseCase, purchaseUseCase: PurchaseUseCase) {
        self.indicatorUseCase = indicatorUseCase
        self.purchaseUseCase = purchaseUseCase
    }
    
    enum Action {
        case addIndicatorButtonTapped
        case explainButtonTapped(String)
        case alarmSwitchTapped(indicatorId: String, isOn: Bool)
        case rightButtonTapped(indicatorId: String, indicatorCoinId: String, coin: String, price: String, indicatorName: String, frequency: String)
        case subscriptionIndicatorItemSelected(Int)
        
        case trialButtonTapped
        case viewOtherIndicatorButtonTapped
        
        case hbbIndicatorItemSelected
        case hbbSelectOtherCoinButtonTapped
        case hbbExplainButtonTapped
        
        case maIndicatorItemSelected
        case maSelectOtherCoinButtonTapped
        case maExplainButtonTapped
        
        case loadIndicatorCoinDatas
        case loadSubscriptionStatus
    }
    
    enum Mutation {
        case setIndicatorCoinDatas([IndicatorCoinData])
        case setSubscriptionStatus(UserSubscriptionStatus)
    }
    
    struct State {
        var hbbIndicatorCoinDatas: [String] = ["BTC","ETH","SOL"]
        var maIndicatorCoinDatas: [String] = ["BTC","ETH","SOL"]
        var indicatorCoinDatas: [IndicatorCoinData] = []
        var subscriptionStatus: UserSubscriptionStatus = UserSubscriptionStatus(user: "", productId: nil, purchaseDate: nil, expiresDate: nil, isTrialPeriod: nil, autoRenewStatus: nil, status: .normal, useTrialYN: "N")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addIndicatorButtonTapped:
            self.steps.accept(AlarmStep.navigateToSelectIndicatorViewController)
            return .empty()
        case .explainButtonTapped(let indicatorId):
            self.steps.accept(AlarmStep.presentToExplainIndicatorSheetPresentationController(indicatorId: indicatorId))
            return .empty()
        case .alarmSwitchTapped(let indicatorId, let isOn):
            let isOn = isOn ? "Y" : "N"
            return indicatorUseCase.updateIndicatorPushState(indicatorId: indicatorId, isOn: isOn)
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        let indicatorCoinDatas = self?.currentState.indicatorCoinDatas.map {
                            var updatedCoinData = $0
                            if String($0.indicatorId) == indicatorId {
                                updatedCoinData.isOn = ($0.isOn == "Y") ? "N" : "Y"
                            }
                            return updatedCoinData
                        }
                        return .just(.setIndicatorCoinDatas(indicatorCoinDatas ?? []))
                    }
                    return .empty()
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .rightButtonTapped(let indicatorId, let indicatorCoinId, let coin, let price, let indicatorName, let frequency):
            self.steps.accept(AlarmStep.navigateToDetailIndicatorCoinViewController(indicatorId: indicatorId, indicatorCoinId: indicatorCoinId, coin: coin, price: price, indicatorName: indicatorName, frequency: frequency))
            return .empty()
        case .subscriptionIndicatorItemSelected(let index):
            let data = currentState.indicatorCoinDatas[index]
            let indicatorId = String(data.indicatorId)
            let indicatorName = LocalizationManager.shared.language == "ko" ? data.indicatorName : data.indicatorNameEng
            let isPremium = data.isPremium == "Y" ? true : false
            let frequency = data.frequency
            self.steps.accept(AlarmStep.navigateToDetailIndicatorViewController(flowType: "WhenNotCreate", indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium, frequency: frequency))
            return .empty()
            
        case .trialButtonTapped:
            self.steps.accept(AlarmStep.goToPurchaseFlow)
            return .empty()
        case .viewOtherIndicatorButtonTapped:
            self.steps.accept(AlarmStep.navigateToSelectIndicatorViewController)
            return .empty()
        
        case .hbbIndicatorItemSelected:
            self.steps.accept(AlarmStep.navigateToSelectCycleForIndicatorViewController(flowType: .atMain, selectCoinForIndicatorFlowType: .atNotPurchase, indicatorId: "1", frequency: "15", targets: ["1","2","3"], indicatorName: LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저밴드"), isPremium: true))
            return .empty()
        case .hbbSelectOtherCoinButtonTapped:
            self.steps.accept(AlarmStep.navigateToSelectCoinForIndicatorViewController(flowType: .atNotPurchase, indicatorId: "1", indicatorName: LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저밴드"), isPremium: true))
            return .empty()
        case .hbbExplainButtonTapped:
            self.steps.accept(AlarmStep.presentToExplainIndicatorSheetPresentationController(indicatorId: "1"))
            return .empty()
        
        case .maIndicatorItemSelected:
            self.steps.accept(AlarmStep.navigateToSelectCycleForIndicatorViewController(flowType: .atMain, selectCoinForIndicatorFlowType: .atNotPurchase, indicatorId: "2", frequency: "15", targets: ["11","12","13"], indicatorName: LocalizationManager.shared.localizedString(forKey: "이동평균선"), isPremium: false))
            return .empty()
        case .maSelectOtherCoinButtonTapped:
            self.steps.accept(AlarmStep.navigateToSelectCoinForIndicatorViewController(flowType: .atNotPurchase, indicatorId: "2", indicatorName: LocalizationManager.shared.localizedString(forKey: "이동평균선"), isPremium: false))
            return .empty()
        case .maExplainButtonTapped:
            self.steps.accept(AlarmStep.presentToExplainIndicatorSheetPresentationController(indicatorId: "2"))
            return .empty()
            
        case .loadIndicatorCoinDatas:
            return indicatorUseCase.getIndicatorCoinData()
                .flatMap { indicatorCoinData -> Observable<Mutation> in
                    
                    return .just(.setIndicatorCoinDatas(indicatorCoinData))
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
        case .setIndicatorCoinDatas(let indicatorCoinDatas):
            newState.indicatorCoinDatas = indicatorCoinDatas
        case .setSubscriptionStatus(let subscriptionStatus):
            newState.subscriptionStatus = subscriptionStatus
        }
        return newState
    }
}
