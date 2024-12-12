import ReactorKit
import RxFlow
import RxCocoa
import Foundation

class TabBarReactor: Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let purchaseUseCase: PurchaseUseCase
    private let hiddenDuration: TimeInterval = 24 * 60 * 60
    
    init(purchaseUseCase: PurchaseUseCase) {
        self.purchaseUseCase = purchaseUseCase
        self.action.onNext(.fetchSubscriptionStatus)
    }
    
    enum Action {
        case tabSelected(index: Int)
        case setTrialTooltipHidden(Bool)
        case fetchSubscriptionStatus
    }
    
    enum Mutation {
        case setTabIndex(Int)
        case setTrialTooltipHidden(Bool)
        case setNotSetAlarmTooltipHidden(Bool)
        case setUserSubscriptionStatus(UserSubscriptionStatus)
    }
    
    struct State {
        var selectedIndex: Int = 0
        var isTrialTooltipHidden: Bool = true
        var isNotSetAlarmTooltipHidden: Bool = true
        var subscriptionStatus: UserSubscriptionStatus = UserSubscriptionStatus(user: "", productId: nil, purchaseDate: nil, expiresDate: nil, isTrialPeriod: nil, autoRenewStatus: nil, status: .normal, useTrialYN: "N")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tabSelected(let index):
            if index == 1 {
                if !currentState.isTrialTooltipHidden {
                    UserDefaultsManager.shared.saveTrialTooltipHiddenTime(Date())
                    return.concat([
                        .just(.setTabIndex(index)),
                        .just(.setTrialTooltipHidden(true)),
                    ])
                }
            }
            return .just(.setTabIndex(index))
        case .setTrialTooltipHidden(let isHidden):
            return .just(.setTrialTooltipHidden(isHidden))
        case .fetchSubscriptionStatus:
            return purchaseUseCase.fetchSubscriptionStatus()
                .flatMap { response -> Observable<Mutation> in
                    let status = response.status
                    let trialYN = response.useTrialYN
                    
                    let isTrialTooltipHidden: Bool
                    if status == .trial || status == .subscription || trialYN == "Y" {
                        isTrialTooltipHidden = true
                    } 
                    else if let lastHiddenTime = UserDefaultsManager.shared.getTrialTooltipHiddenTime() {
                        let elapsedTime = Date().timeIntervalSince(lastHiddenTime)
                        isTrialTooltipHidden = elapsedTime < self.hiddenDuration
                    } 
                    else {
                        isTrialTooltipHidden = false
                    }
                    if trialYN == "N" {
                        if let lastHiddenTime = UserDefaultsManager.shared.getNewIndicatorHiddenTime() {
                            let elapsedTime = Date().timeIntervalSince(lastHiddenTime)
                            if elapsedTime < self.hiddenDuration {
                                print("24시간 안지남")
                            }
                            else {
                                print("24시간 지남")
                                self.steps.accept(TabBarStep.presentToNewIndicatorViewController)
                                UserDefaultsManager.shared.saveNewIndicatorHiddenTime(Date())
                            }
                        }
                        else {
                            print("처음 시작")
                            self.steps.accept(TabBarStep.presentToNewIndicatorViewController)
                            UserDefaultsManager.shared.saveNewIndicatorHiddenTime(Date())
                        }
                    }
                    
                    let isNotSetAlarmTooltipHidden = UserDefaultsManager.shared.getIsNotSetAlarmTooltipHidden()
                    
                    return Observable.concat([
                        .just(.setTrialTooltipHidden(isTrialTooltipHidden)),
                        .just(.setNotSetAlarmTooltipHidden(isNotSetAlarmTooltipHidden)),
                        .just(.setUserSubscriptionStatus(response))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AppStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTabIndex(let index):
            newState.selectedIndex = index
        case .setTrialTooltipHidden(let isHidden):
            newState.isTrialTooltipHidden = isHidden
        case .setNotSetAlarmTooltipHidden(let isHidden):
            newState.isNotSetAlarmTooltipHidden = isHidden
        case .setUserSubscriptionStatus(let subscriptionStatus):
            newState.subscriptionStatus = subscriptionStatus
        }
        return newState
    }
}
