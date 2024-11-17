import ReactorKit
import UIKit
import Foundation
import RxCocoa
import RxFlow

class SettingReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let userUseCase: UserUseCase
    private let purchaseUseCase: PurchaseUseCase
    
    init(userUseCase: UserUseCase, purchaseUseCase: PurchaseUseCase) {
        self.initialState = State(currentLanguage: LocalizationManager.shared.language)
        self.userUseCase = userUseCase
        self.purchaseUseCase = purchaseUseCase
    }
    
    enum Action {
        case rightButtonTapped
        case normalUserViewTapped
        case trialUserViewTapped
        case subscriptionUserViewTapped
        case changeLanguage(String)
        case alarmSettingButtonTapped
        case inquiryButtonTapped
        case termsOfServiceButtonTapped
        case privacyPolicyButtonTapped
        case fetchUserData
    }
    
    enum Mutation {
        case setLanguage(String)
        case setUserSubscriptionStatus(UserSubscriptionStatus)
        case setImageIndex(String)
        case setNickname(String)
    }
    
    struct State {
        var currentLanguage: String
        var subscriptionStatus: UserSubscriptionStatus = UserSubscriptionStatus(user: "", productId: nil, purchaseDate: nil, expiresDate: nil, isTrialPeriod: nil, autoRenewStatus: nil, status: .normal, useTrialYN: "N")
        var imageIndex: String = "1"
        var nickname: String = ""
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .rightButtonTapped:
            self.steps.accept(SettingStep.navigateToMyAccountViewController)
            return .empty()
        case .normalUserViewTapped:
            self.steps.accept(SettingStep.goToPurchaseFlow)
            return .empty()
        case .trialUserViewTapped:
            return .empty()
        case .subscriptionUserViewTapped:
            return .empty()
        case .changeLanguage(let newLanguage):
            LocalizationManager.shared.setLanguage(newLanguage)
            return .just(.setLanguage(newLanguage))
        case .alarmSettingButtonTapped:
            self.steps.accept(SettingStep.goToAlarmSetting)
            return .empty()
        case .inquiryButtonTapped:
            self.steps.accept(SettingStep.navigateToInquiryViewController)
            return .empty()
        case .termsOfServiceButtonTapped:
            self.steps.accept(SettingStep.navigateToTermsOfServiceViewController)
            return .empty()
        case .privacyPolicyButtonTapped:
            self.steps.accept(SettingStep.navigateToPrivacyPolicyViewController)
            return .empty()
        case .fetchUserData:
            let userDataObservable = userUseCase.fetchUserData()
            let subscriptionStatusObservable = purchaseUseCase.fetchSubscriptionStatus()
            
            return Observable.zip(userDataObservable, subscriptionStatusObservable)
                .flatMap { userData, subscriptionStatus -> Observable<Mutation> in
                    return .concat([
                        .just(.setImageIndex(userData.imgIndex)),
                        .just(.setNickname(userData.nickname)),
                        .just(.setUserSubscriptionStatus(subscriptionStatus))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: SettingStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLanguage(let newLanguage):
            newState.currentLanguage = newLanguage
        case .setUserSubscriptionStatus(let subscriptionStatus):
            newState.subscriptionStatus = subscriptionStatus
        case .setImageIndex(let index):
            newState.imageIndex = index
        case .setNickname(let nickname):
            newState.nickname = nickname
        }
        return newState
    }
}
