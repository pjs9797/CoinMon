import UIKit
import RxFlow
import RxCocoa

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
        case .presentToSelectDepartureMarketViewController(let selectedMarketRelay):
            return presentToSelectDepartureMarketViewController(selectedMarketRelay: selectedMarketRelay)
        case .presentToSelectArrivalMarketViewController(let selectedMarketRelay):
            return presentToSelectArrivalMarketViewController(selectedMarketRelay: selectedMarketRelay)
        case .dismissSelectMarketViewController:
            return dismissSelectMarketViewController()
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

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: viewController, withNextStepper: reactor),
            .contribute(withNextPresentable: premiumViewController, withNextStepper: premiumReactor),
        ])
    }
    
    private func presentToSelectDepartureMarketViewController(selectedMarketRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectMarketAtHomeReactor(selectMarketFlow: .departure, selectedMarketRelay: selectedMarketRelay)
        let viewController = SelectMarketViewAtHomeController(with: reactor)
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
    
    private func presentToSelectArrivalMarketViewController(selectedMarketRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectMarketAtHomeReactor(selectMarketFlow: .arrival, selectedMarketRelay: selectedMarketRelay)
        let viewController = SelectMarketViewAtHomeController(with: reactor)
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
    
    private func dismissSelectMarketViewController() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
}
