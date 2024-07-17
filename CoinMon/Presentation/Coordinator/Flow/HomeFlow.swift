import UIKit
import RxFlow
import RxCocoa

class HomeFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let coinUseCase = CoinUseCase(repository: CoinRepository())
    
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
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .dismissSelectMarketViewController:
            return dismissSelectMarketViewController()
        }
    }
    
    private func navigateToHomeViewController() -> FlowContributors {
        let priceReactor = PriceReactor(coinUseCase: coinUseCase)
        let priceViewController = PriceViewController(with: priceReactor)
        
        let feeReactor = FeeReactor(coinUseCase: coinUseCase)
        let feeViewController = FeeViewController(with: feeReactor)
        
        let premiumReactor = PremiumReactor(coinUseCase: coinUseCase)
        let premiumViewController = PremiumViewController(with: premiumReactor)
        
        let reactor = HomeReactor()
        let viewController = HomeViewController(with: reactor, viewControllers: [priceViewController,feeViewController,premiumViewController])
        self.rootViewController.pushViewController(viewController, animated: true)

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: viewController.pageViewController, withNextStepper: premiumReactor),
            .contribute(withNextPresentable: priceViewController, withNextStepper: priceReactor),
            .contribute(withNextPresentable: feeViewController, withNextStepper: feeReactor),
            .contribute(withNextPresentable: viewController, withNextStepper: reactor)
        ])
    }
    
    private func presentToSelectDepartureMarketViewController(selectedMarketRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectMarketAtHomeReactor(selectMarketFlow: .departure, selectedMarketRelay: selectedMarketRelay)
        let viewController = SelectMarketViewAtHomeController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 228*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectArrivalMarketViewController(selectedMarketRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectMarketAtHomeReactor(selectMarketFlow: .arrival, selectedMarketRelay: selectedMarketRelay)
        let viewController = SelectMarketViewAtHomeController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 228*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToNetworkErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "네트워크 오류"),
                                                message: LocalizationManager.shared.localizedString(forKey: "네트워크 오류 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func dismissSelectMarketViewController() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
}
