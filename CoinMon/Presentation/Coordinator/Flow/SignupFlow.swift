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
        case .navigateToSignupEmailEntryViewController:
            return navigateToSignupEmailEntryViewController()
        case .navigateToSignupPhoneNumberEntryViewController:
            return navigateToSignupPhoneNumberEntryViewController()
        case .navigateToVerificationNumberViewController:
            return navigateToVerificationNumberViewController()
        case .navigateToSignupCompletedViewController:
            return navigateToSignupCompletedViewController()
        case .popViewController:
            return popViewController()
        case .popToRootViewController:
            return popToRootViewController()
        case .completeSignupFlow:
            return completeSignupFlow()
        }
    }
    
    private func navigateToSignupEmailEntryViewController() -> FlowContributors {
        let reactor = EmailEntryReactor(flowState: EmailEntryFlow.Signup)
        let viewController = SignupEmailEntryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSignupPhoneNumberEntryViewController() -> FlowContributors {
        let reactor = SignupPhoneNumberEntryReactor()
        let viewController = SignupPhoneNumberEntryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToVerificationNumberViewController() -> FlowContributors {
        let reactor = VerificationNumberReactor(flowState: EmailEntryFlow.Signup)
        let viewController = SignupVerificationNumberViewController(with: reactor)
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
    
    private func completeSignupFlow() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        //TODO: 탭바 만들면 탭바뷰컨으로 이동되게
        return .end(forwardToParentFlowWithStep: AppStep.completeSignupFlow)
    }
}
