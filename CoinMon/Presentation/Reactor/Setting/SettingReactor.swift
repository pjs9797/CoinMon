import ReactorKit
import UIKit
import Foundation
import RxCocoa
import RxFlow

class SettingReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    
    init() {
        self.initialState = State(currentLanguage: LocalizationManager.shared.language)
    }
    
    enum Action {
        case changeLanguage(String)
        case alarmSettingButtonTapped
        case myAccountButtonTapped
        case inquiryButtonTapped
        case termsOfServiceButtonTapped
        case privacyPolicyButtonTapped
    }
    
    enum Mutation {
        case setLanguage(String)
    }
    
    struct State {
        var currentLanguage: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeLanguage(let newLanguage):
            LocalizationManager.shared.setLanguage(newLanguage)
            return Observable.just(.setLanguage(newLanguage))
        case .alarmSettingButtonTapped:
            self.steps.accept(SettingStep.goToAlarmSetting)
            return .empty()
        case .myAccountButtonTapped:
            self.steps.accept(SettingStep.navigateToMyAccountViewController)
            return .empty()
        case .inquiryButtonTapped:
//            let chatURL = URL(string: "https://open.kakao.com/o/gxZ2CNtg")!
//            let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id362057947")!
//
//            if UIApplication.shared.canOpenURL(chatURL) {
//                UIApplication.shared.open(chatURL, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
//            }
            if let url = URL(string: "https://coinpannews.com/%eb%b9%84%ed%8a%b8%ec%bd%94%ec%9d%b8-%eb%8b%a8%ea%b8%b0-otm-%ed%92%8b-%ec%98%b5%ec%85%98%ec%84%9c-iv-%ec%a6%9d%ea%b0%80-%ed%8a%b8%eb%a0%88%ec%9d%b4%eb%8d%94%eb%93%a4-%ed%95%98%eb%9d%bd-%eb%8c%80/") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            //self.steps.accept(SettingStep.navigateToInquiryViewController)
            return .empty()
        case .termsOfServiceButtonTapped:
            self.steps.accept(SettingStep.navigateToTermsOfServiceViewController)
            return .empty()
        case .privacyPolicyButtonTapped:
            self.steps.accept(SettingStep.navigateToPrivacyPolicyViewController)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLanguage(let newLanguage):
            newState.currentLanguage = newLanguage
        }
        return newState
    }
}
