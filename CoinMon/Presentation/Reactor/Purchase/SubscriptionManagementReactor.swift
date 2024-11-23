import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class SubscriptionManagementReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let flowType: FlowType
    private let purchaseUseCase: PurchaseUseCase
    
    init(flowType: FlowType, purchaseUseCase: PurchaseUseCase) {
        self.flowType = flowType
        self.purchaseUseCase = purchaseUseCase
    }
    
    enum Action {
        case backButtonTapped
        case contactButtonTapped
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
        case .backButtonTapped:
            switch flowType {
            case .setting:
                self.steps.accept(SettingStep.popViewController)
            case .purchase:
                self.steps.accept(PurchaseStep.popViewController)
            default:
                return .empty()
            }
            return .empty()
        case .contactButtonTapped:
            let kakaoURL = "https://open.kakao.com/o/gxZ2CNtg"
            let kakaoAppStoreURL = "itms-apps://itunes.apple.com/app/id362057947"
            self.steps.accept(PurchaseStep.goToOpenURL(url: kakaoURL, fallbackUrl: kakaoAppStoreURL))
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
    
    func getNextPaymentDate(expiryDateString: String) -> (String, String, String)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // 만료일 문자열을 Date 객체로 변환
        guard let expiryDate = dateFormatter.date(from: expiryDateString) else {
            return nil // 날짜 형식이 맞지 않으면 nil 반환
        }
        
        // 한 달을 추가
        guard let nextPaymentDate = Calendar.current.date(byAdding: .month, value: 1, to: expiryDate) else {
            return nil // 날짜 계산 실패 시 nil 반환
        }
        
        // 결제 예정일을 문자열로 변환
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: nextPaymentDate)
        
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: nextPaymentDate)
        
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: nextPaymentDate)
        
        return (year, month, day)
    }
}
