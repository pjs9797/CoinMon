import UIKit
import RxFlow

class SettingFlow: Flow {
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
        guard let step = step as? SettingStep else { return .none }
        switch step {
        case .navigateToSettingViewController:
            return navigateToSettingViewController()
        case .navigateToMyAccountViewController:
            return navigateToMyAccountViewController()
        case .navigateToWithdrawalViewController:
            return navigateToWithdrawalViewController()
        case .popViewController:
            return popViewController()
        }
    }
    
    private func navigateToSettingViewController() -> FlowContributors {
        let reactor = SettingReactor()
        let viewController = SettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToMyAccountViewController() -> FlowContributors {
        let reactor = MyAccountReactor()
        let viewController = MyAccountViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToWithdrawalViewController() -> FlowContributors {
        let reactor = WithdrawalReactor()
        let viewController = WithdrawalViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
