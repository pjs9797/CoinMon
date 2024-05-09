import UIKit
import RxFlow

class SigninFlow: Flow {
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
        guard let step = step as? SigninStep else { return .none }
        switch step {
        case .navigateToSigninEmailEntryViewController:
            return navigateToSigninEmailEntryViewController()
        case .navigateToVerificationNumberViewController:
            return navigateToVerificationNumberViewController()
        case .popViewController:
            return popViewController()
        case .popToRootViewController:
            return popToRootViewController()
        case .completeSigninFlow:
            return completeSigninFlow()
        }
    }
    
    private func navigateToSigninEmailEntryViewController() -> FlowContributors {
        let reactor = EmailEntryReactor(flowState: EmailEntryFlow.Signin)
        let viewController = SigninEmailEntryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToVerificationNumberViewController() -> FlowContributors {
        let reactor = VerificationNumberReactor(flowState: EmailEntryFlow.Signin)
        let viewController = SigninVerificationNumberViewController(with: reactor)
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
    
    private func completeSigninFlow() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        //TODO: 탭바 만들면 탭바뷰컨으로 이동되게
        return .end(forwardToParentFlowWithStep: AppStep.completeSigninFlow)
    }
}
