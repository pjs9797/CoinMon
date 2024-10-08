import UIKit
import RxFlow

class SettingFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let userUseCase: UserUseCase
    private let stepper: SettingStepper
    
    init(with rootViewController: UINavigationController, userUseCase: UserUseCase, stepper: SettingStepper) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.userUseCase = userUseCase
        self.stepper = stepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SettingStep else { return .none }
        switch step {
        case .navigateToSettingViewController:
            return navigateToSettingViewController()
        case .navigateToMyAccountViewController:
            return navigateToMyAccountViewController()
        case .navigateToInquiryViewController:
            return navigateToInquiryViewController()
        case .navigateToWithdrawalViewController:
            return navigateToWithdrawalViewController()
        case .navigateToTermsOfServiceViewController:
            return navigateToTermsOfServiceViewController()
        case .navigateToPrivacyPolicyViewController:
            return navigateToPrivacyPolicyViewController()
            
        case .presentToDuplicatedNicknameErrorAlertController:
            return presentToDuplicatedNicknameErrorAlertController()
        case .presentToLogoutAlertController(let reactor):
            return presentToLogoutAlertController(reactor: reactor)
        case .presentToWithdrawAlertController(let reactor):
            return presentToWithdrawAlertController(reactor: reactor)
            
            // 프레젠트 공통 알람
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController:
            return presentToUnknownErrorAlertController()
        case .presentToExpiredTokenErrorAlertController:
            return presentToExpiredTokenErrorAlertController()
        case .presentToAWSServerErrorAlertController:
            return presentToAWSServerErrorAlertController()
            
        case .goToAlarmSetting:
            return goToAlarmSetting()
        case .goToOpenURL(let url, let fallbackUrl):
            return goToOpenURL(url: url, fallbackUrl: fallbackUrl)
            
        case .popViewController:
            return popViewController()
            
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.completeMainFlow)
        case .endFlowAfterWithdrawal:
            return .end(forwardToParentFlowWithStep: AppStep.completeMainFlowAfterWithdrawal)
        }
    }
    
    private func navigateToSettingViewController() -> FlowContributors {
        let reactor = SettingReactor()
        let viewController = SettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToMyAccountViewController() -> FlowContributors {
        let reactor = MyAccountReactor(userUseCase: self.userUseCase)
        let viewController = MyAccountViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToInquiryViewController() -> FlowContributors {
        let reactor = InquiryReactor()
        let viewController = InquiryViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToWithdrawalViewController() -> FlowContributors {
        let reactor = WithdrawalReactor(userUseCase: self.userUseCase)
        let viewController = WithdrawalViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTermsOfServiceViewController() -> FlowContributors {
        let reactor = TermsOfServiceReactor(termsOfServiceFlow: .setting)
        let viewController = TermsOfServiceViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPrivacyPolicyViewController() -> FlowContributors {
        let reactor = PrivacyPolicyReactor(termsOfServiceFlow: .setting)
        let viewController = PrivacyPolicyViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToDuplicatedNicknameErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
                                                message: LocalizationManager.shared.localizedString(forKey: "중복되는 닉네임이에요"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToLogoutAlertController(reactor: MyAccountReactor) -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
                                                message: LocalizationManager.shared.localizedString(forKey: "로그아웃알림"),
                                                preferredStyle: .alert)
        let noAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "아니요"), style: .default, handler: nil)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "네"), style: .default) { _ in
            reactor.action.onNext(.logoutAlertYesButtonTapped)
        }
        alertController.addAction(noAction)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)

        return .none
    }
    
    private func presentToWithdrawAlertController(reactor: WithdrawalReactor) -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "탈퇴알림"),
                                                message: LocalizationManager.shared.localizedString(forKey: "코인몬을 이용해 주셔서 감사합니다."),
                                                preferredStyle: .alert)
        let noAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "아니요"), style: .default, handler: nil)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default) { _ in
            reactor.action.onNext(.withdrawAlertOkButtonTapped)
        }
        alertController.addAction(noAction)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToNetworkErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "네트워크 오류"),
                                                message: LocalizationManager.shared.localizedString(forKey: "네트워크 오류 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToUnknownErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "알 수 없는 오류 발생"),
                                                message: LocalizationManager.shared.localizedString(forKey: "알 수 없는 오류 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToExpiredTokenErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "로그인 만료"),
                                                message: LocalizationManager.shared.localizedString(forKey: "로그인 만료 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default) { [weak self] _ in
            self?.stepper.resetFlow()
        }
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToAWSServerErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "서버 오류"),
                                                message: LocalizationManager.shared.localizedString(forKey: "서버 오류 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func goToAlarmSetting() -> FlowContributors {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .none
    }
    
    private func goToOpenURL(url: String, fallbackUrl: String) -> FlowContributors {
        let url = URL(string: url)!
        let fallbackUrl = URL(string: fallbackUrl)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(fallbackUrl, options: [:], completionHandler: nil)
        }
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
