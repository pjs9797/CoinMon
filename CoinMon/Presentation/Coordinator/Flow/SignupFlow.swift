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
        case .popViewController:
            return popViewController()
        case .completeSignupFlow:
            return completeSignupFlow()
        }
    }
    
    private func navigateToSignupEmailEntryViewController() -> FlowContributors {
        let reactor = EmailEntryReactor()
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
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func completeSignupFlow() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        
        return .end(forwardToParentFlowWithStep: AppStep.completeSignupFlow)
    }
}
