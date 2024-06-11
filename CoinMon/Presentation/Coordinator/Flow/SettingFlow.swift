import UIKit
import RxFlow

class SettingFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let userUseCase = UserUseCase(repository: UserRepository())
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SettingStep else { return .none }
        switch step {
        case .navigateToSettingViewController:
            return navigateToSettingViewController()
        case .navigateToMyAccountViewController:
            return navigateToMyAccountViewController()
        case .navigateToWithdrawalViewController:
            return navigateToWithdrawalViewController()
        case .navigateToTermsOfServiceViewController:
            return navigateToTermsOfServiceViewController()
        case .navigateToPrivacyPolicyViewController:
            return navigateToPrivacyPolicyViewController()
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToDuplicatedNicknameErrorAlertController:
            return presentToDuplicatedNicknameErrorAlertController()
        case .presentToLogoutAlertController(let reactor):
            return presentToLogoutAlertController(reactor: reactor)
        case .presentToWithdrawAlertController(let reactor):
            return presentToWithdrawAlertController(reactor: reactor)
        case .popViewController:
            return popViewController()
        case .completeMainFlow:
            return .end(forwardToParentFlowWithStep: AppStep.completeMainFlow)
        }
    }
    
    private func navigateToSettingViewController() -> FlowContributors {
        let reactor = SettingReactor()
        let viewController = SettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToMyAccountViewController() -> FlowContributors {
        let reactor = MyAccountReactor(userUseCase: userUseCase)
        let viewController = MyAccountViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToWithdrawalViewController() -> FlowContributors {
        let reactor = WithdrawalReactor(userUseCase: userUseCase)
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
    
    private func presentToNetworkErrorAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: LocalizationManager.shared.localizedString(forKey: "네트워크 오류"),
                                                message: LocalizationManager.shared.localizedString(forKey: "네트워크 오류 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToDuplicatedNicknameErrorAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: nil,
                                                message: LocalizationManager.shared.localizedString(forKey: "중복되는 닉네임이에요"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToLogoutAlertController(reactor: MyAccountReactor) -> FlowContributors {
        let alertController = UIAlertController(title: nil,
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
        let alertController = UIAlertController(title: nil,
                                                message: LocalizationManager.shared.localizedString(forKey: "탈퇴알림"),
                                                preferredStyle: .alert)
        let noAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "아니요"), style: .default, handler: nil)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "네"), style: .default) { _ in
            reactor.action.onNext(.withdrawAlertYesButtonTapped)
        }
        alertController.addAction(noAction)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
