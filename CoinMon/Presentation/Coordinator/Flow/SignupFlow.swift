import UIKit
import RxFlow

class SignupFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let signupUseCase = SignupUseCase(repository: SignupRepository())
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SignupStep else { return .none }
        switch step {
        case .navigateToSignupEmailEntryViewController:
            return navigateToSignupEmailEntryViewController()
        case .navigateToSignupEmailVerificationNumberViewController:
            return navigateToSignupEmailVerificationNumberViewController()
        case .navigateToSignupPhoneNumberEntryViewController:
            return navigateToSignupPhoneNumberEntryViewController()
        case .presentToAgreeToTermsOfServiceViewController:
            return presentToAgreeToTermsOfServiceViewController()
        case .navigateToTermsOfServiceViewController:
            return navigateToTermsOfServiceViewController()
        case .navigateToPrivacyPolicyViewController:
            return navigateToPrivacyPolicyViewController()
        case .navigateToMarketingConsentViewController:
            return navigateToMarketingConsentViewController()
        case .navigateToPhoneVerificationNumberViewController:
            return navigateToPhoneVerificationNumberViewController()
        case .navigateToSignupCompletedViewController:
            return navigateToSignupCompletedViewController()
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToAuthenticationNumberErrorAlertController:
            return presentToAuthenticationNumberErrorAlertController()
        case .presentToAlreadysubscribedNumberErrorAlertController:
            return presentToAlreadysubscribedNumberErrorAlertController()
        case .popViewController:
            return popViewController()
        case .popToRootViewController:
            return popToRootViewController()
        case .dismissViewController:
            return dismissViewController()
        case .completeSignupFlow:
            return completeSignupFlow()
        }
    }
    
    private func navigateToSignupEmailEntryViewController() -> FlowContributors {
        let reactor = SignupEmailEntryReactor(signupUseCase: signupUseCase)
        let viewController = SignupEmailEntryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSignupEmailVerificationNumberViewController() -> FlowContributors {
        let reactor = SignupEmailVerificationNumberReactor(signupUseCase: signupUseCase)
        let viewController = SignupEmailVerificationNumberViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSignupPhoneNumberEntryViewController() -> FlowContributors {
        let reactor = SignupPhoneNumberEntryReactor(signupUseCase: signupUseCase)
        let viewController = SignupPhoneNumberEntryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToAgreeToTermsOfServiceViewController() -> FlowContributors {
        let reactor = AgreeToTermsOfServiceReactor(signupUseCase: signupUseCase)
        let viewController = AgreeToTermsOfServiceViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 348*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTermsOfServiceViewController() -> FlowContributors {
        let reactor = TermsOfServiceReactor(termsOfServiceFlow: .signup)
        let viewController = TermsOfServiceViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPrivacyPolicyViewController() -> FlowContributors {
        let reactor = PrivacyPolicyReactor(termsOfServiceFlow: .signup)
        let viewController = PrivacyPolicyViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToMarketingConsentViewController() -> FlowContributors {
        let reactor = MarketingConsentReactor(termsOfServiceFlow: .signup)
        let viewController = MarketingConsentViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPhoneVerificationNumberViewController() -> FlowContributors {
        let reactor = PhoneVerificationNumberReactor(signupUseCase: signupUseCase)
        let viewController = PhoneVerificationNumberViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSignupCompletedViewController() -> FlowContributors {
        let reactor = SignupCompletedReactor()
        let viewController = SignupCompletedViewController(with: reactor)
        self.rootViewController.navigationBar.isHidden = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
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
    
    private func presentToAuthenticationNumberErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
            message: LocalizationManager.shared.localizedString(forKey: "인증번호 불일치"),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToAlreadysubscribedNumberErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
            message: LocalizationManager.shared.localizedString(forKey: "가입된 번호"),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func popToRootViewController() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        
        return .end(forwardToParentFlowWithStep: AppStep.popToRootViewController)
    }
    
    private func dismissViewController() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func completeSignupFlow() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        
        return .end(forwardToParentFlowWithStep: AppStep.completeSignupFlow)
    }
}
