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
        case .navigateToLoginViewController:
            return navigateToLoginViewController()
        case .popViewController:
            return popViewController()
        case .goToSignupFlow:
            return goToSignupFlow()
        case .completeSignupFlow:
            return .none
        }
    }
    
    private func navigateToLoginViewController() -> FlowContributors {
        let reactor = LoginReactor()
        let viewController = LoginViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func goToSignupFlow() -> FlowContributors {
        let signupFlow = SignupFlow(with: self.rootViewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: signupFlow, withNextStepper: OneStepper(withSingleStep: SignupStep.navigateToSignupEmailEntryViewController)))
    }
}

