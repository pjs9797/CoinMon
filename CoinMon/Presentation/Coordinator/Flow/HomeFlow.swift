import UIKit
import RxFlow

class HomeFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.rootViewController.isNavigationBarHidden = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return .none }
        switch step {
        case .navigateToHomeViewController:
            return navigateToHomeViewController()
        }
    }
    
    private func navigateToHomeViewController() -> FlowContributors {
        let priceReactor = PriceReactor()
        let priceViewController = PriceViewController(with: priceReactor)
        
        let reactor = HomeReactor()
        let viewController = HomeViewController(with: reactor, viewControllers: [priceViewController])
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
}
