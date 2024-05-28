import UIKit
import RxFlow

class SignupFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SignupStep else { return .none }
        switch step {
        case .navigateToEmailEntryViewController:
            return navigateToEmailEntryViewController()
        case .navigateToEmailVerificationNumberViewController:
            return navigateToEmailVerificationNumberViewController()
        case .navigateToSignupPhoneNumberEntryViewController:
            return navigateToSignupPhoneNumberEntryViewController()
        case .presentToTermsOfServiceViewController:
            return presentToTermsOfServiceViewController()
        case .navigateToPhoneVerificationNumberViewController:
            return navigateToPhoneVerificationNumberViewController()
        case .navigateToSignupCompletedViewController:
            return navigateToSignupCompletedViewController()
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
    
    private func navigateToEmailEntryViewController() -> FlowContributors {
        let reactor = EmailEntryReactor(emailFlow: .signup)
        let viewController = EmailEntryViewController(with: reactor, emailFlow: .signup)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToEmailVerificationNumberViewController() -> FlowContributors {
        let reactor = EmailVerificationNumberReactor(emailFlow: .signup)
        let viewController = EmailVerificationNumberViewController(with: reactor, emailFlow: .signup)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSignupPhoneNumberEntryViewController() -> FlowContributors {
        let reactor = SignupPhoneNumberEntryReactor()
        let viewController = SignupPhoneNumberEntryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToTermsOfServiceViewController() -> FlowContributors {
        let reactor = TermsOfServiceReactor()
        let viewController = TermsOfServiceViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 348*Constants.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*Constants.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPhoneVerificationNumberViewController() -> FlowContributors {
        let reactor = PhoneVerificationNumberReactor()
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
        //TODO: 탭바 만들면 탭바뷰컨으로 이동되게
        return .end(forwardToParentFlowWithStep: AppStep.completeSignupFlow)
    }
}
