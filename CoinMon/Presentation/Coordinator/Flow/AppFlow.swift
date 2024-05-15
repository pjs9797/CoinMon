import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .navigateToSigninViewController:
            return navigateToSigninViewController()
        case .popViewController:
            return popViewController()
        case .popToRootViewController:
            return .none
        case .goToSignupFlow:
            return goToSignupFlow()
        case .goToSigninFlow:
            return goToSigninFlow()
        case .completeSignupFlow:
            return .none
        case .completeSigninFlow:
            return .none
        }
    }
    
    private func navigateToSigninViewController() -> FlowContributors {
        let reactor = SigninReactor()
        let viewController = SigninViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func goToSignupFlow() -> FlowContributors {
        let signupFlow = SignupFlow(with: self.rootViewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: signupFlow, withNextStepper: OneStepper(withSingleStep: SignupStep.navigateToEmailEntryViewController)))
    }
    
    private func goToSigninFlow() -> FlowContributors {
        let signinFlow = SigninFlow(with: self.rootViewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: signinFlow, withNextStepper: OneStepper(withSingleStep: SigninStep.navigateToEmailEntryViewController)))
    }
}

