import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class SuccessSubscriptionReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let purchaseUseCase: PurchaseUseCase
    private let flowType: FlowType
    
    init(flowType: FlowType, purchaseUseCase: PurchaseUseCase) {
        self.flowType = flowType
        self.purchaseUseCase = purchaseUseCase
    }
        
    enum Action {
        case presentAlertController
        case backButtonTapped
        case managementButtonTapped
        case loadSubscriptionStatus
    }
    
    enum Mutation {
        case setSubscriptionStatus(UserSubscriptionStatus)
    }
    
    struct State {
        var subscriptionStatus: UserSubscriptionStatus = UserSubscriptionStatus(user: "", productId: nil, purchaseDate: nil, expiresDate: nil, isTrialPeriod: nil, autoRenewStatus: nil, status: .normal, useTrialYN: "N")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .presentAlertController:
            self.steps.accept(PurchaseStep.presentToSuccessPurchaseAlertController)
            return .empty()
        case .backButtonTapped:
            switch flowType {
            case .setting:
                self.steps.accept(SettingStep.popDownWithAnimation)
            case .purchase:
                self.steps.accept(PurchaseStep.navigateToSelectCoinForIndicatorViewController(flowType: .purchase, indicatorId: "1", indicatorName: LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저밴드"), isPremium: true))
            default:
                return .empty()
            }
            return .empty()
        case .managementButtonTapped:
            switch flowType {
            case .setting:
                self.steps.accept(SettingStep.navigateToSubscriptionManagementViewController)
            case .purchase:
                self.steps.accept(PurchaseStep.navigateToSubscriptionManagementViewController)
            default:
                return .empty()
            }
            return .empty()
        case .loadSubscriptionStatus:
            return purchaseUseCase.fetchSubscriptionStatus()
                .flatMap { subscriptionStatus -> Observable<Mutation> in
                    return .just(.setSubscriptionStatus(subscriptionStatus))
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: PurchaseStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSubscriptionStatus(let subscriptionStatus):
            newState.subscriptionStatus = subscriptionStatus
        }
        return newState
    }
    
    func convertDateToTuple(dateString: String) -> (String, String, String)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        
        return (year, month, day)
    }
}
