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
        case .presentToSelectDepartureExchangeViewController:
            return presentToSelectDepartureExchangeViewController()
        case .presentToSelectArrivalExchangeViewController:
            return presentToSelectArrivalExchangeViewController()
        case .dismissSelectExchangeViewController:
            return dismissSelectExchangeViewController()
        }
    }
    
    private func navigateToHomeViewController() -> FlowContributors {
        let priceReactor = PriceReactor()
        let priceViewController = PriceViewController(with: priceReactor)
        
        let feeReactor = FeeReactor()
        let feeViewController = FeeViewController(with: feeReactor)
        
        let premiumReactor = PremiumReactor()
        let premiumViewController = PremiumViewController(with: premiumReactor)
        
        let reactor = HomeReactor()
        let viewController = HomeViewController(with: reactor, viewControllers: [priceViewController,feeViewController,premiumViewController])
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectDepartureExchangeViewController() -> FlowContributors {
        let reactor = SelectExchangeReactor(selectExchangeFlow: .departure)
        let viewController = SelectExchangeViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 228*Constants.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*Constants.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectArrivalExchangeViewController() -> FlowContributors {
        let reactor = SelectExchangeReactor(selectExchangeFlow: .arrival)
        let viewController = SelectExchangeViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 228*Constants.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*Constants.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func dismissSelectExchangeViewController() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    
}
