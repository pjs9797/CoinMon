import UIKit
import RxFlow
import RxCocoa

class HomeFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let coinUseCase: CoinUseCase
    private let alarmUseCase: AlarmUseCase
    
    init(with rootViewController: UINavigationController, coinUseCase: CoinUseCase, alarmUseCase: AlarmUseCase) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.rootViewController.isNavigationBarHidden = true
        self.coinUseCase = coinUseCase
        self.alarmUseCase = alarmUseCase
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return .none }
        switch step {
        case .navigateToHomeViewController:
            return navigateToHomeViewController()
        case .navigateToNotificationViewController:
            return navigateToNotificationViewController()
        case .navigateToDetailCoinInfoViewController(let market, let coin):
            return navigateToDetailCoinInfoViewController(market: market, coin: coin)
        case .presentToSelectDepartureMarketViewController(let selectedMarketRelay, let selectedMarketLocalizationKey):
            return presentToSelectDepartureMarketViewController(selectedMarketRelay: selectedMarketRelay, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        case .presentToSelectArrivalMarketViewController(let selectedMarketRelay, let selectedMarketLocalizationKey):
            return presentToSelectArrivalMarketViewController(selectedMarketRelay: selectedMarketRelay, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .goToAlarmSetting:
            return goToAlarmSetting()
        case .dismissSelectMarketViewController:
            return dismissSelectMarketViewController()
        case .popViewController:
            return popViewController()
        }
    }
    
    private func navigateToHomeViewController() -> FlowContributors {
        let priceReactor = PriceReactor(coinUseCase: self.coinUseCase)
        let priceViewController = PriceViewController(with: priceReactor)
        
        let feeReactor = FeeReactor(coinUseCase: self.coinUseCase)
        let feeViewController = FeeViewController(with: feeReactor)
        
        let premiumReactor = PremiumReactor(coinUseCase: self.coinUseCase)
        let premiumViewController = PremiumViewController(with: premiumReactor)
        
        let reactor = HomeReactor()
        let viewController = HomeViewController(with: reactor, viewControllers: [priceViewController,feeViewController,premiumViewController])
        let compositeStepper = CompositeStepper(steppers: [priceReactor, feeReactor, premiumReactor, reactor])
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: compositeStepper))
    }
    
    private func navigateToNotificationViewController() -> FlowContributors {
        let reactor = NotificationReactor(alarmUseCase: self.alarmUseCase)
        let viewController = NotificationViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToDetailCoinInfoViewController(market: String, coin: String) -> FlowContributors {
        let chartReactor = ChartReactor(market: market, coin: coin)
        let chartViewController = ChartViewController(with: chartReactor)
        
        let infoReactor = InfoReactor()
        let infoViewController = InfoViewController(with: infoReactor)
        
        //let premiumReactor = PremiumReactor(coinUseCase: self.coinUseCase)
        let communityViewController = CommunityViewController()
        
        let reactor = DetailCoinInfoReactor(coinUseCase: self.coinUseCase, market: market, coin: coin)
        let viewController = DetailCoinInfoViewController(with: reactor, viewControllers: [chartViewController,infoViewController,communityViewController])
        viewController.hidesBottomBarWhenPushed = true
        let compositeStepper = CompositeStepper(steppers: [infoReactor, chartReactor, reactor])
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: compositeStepper))
    }
    
    private func presentToSelectDepartureMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String) -> FlowContributors {
        let reactor = SelectMarketAtHomeReactor(selectMarketFlow: .departure, selectedMarketRelay: selectedMarketRelay, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        let viewController = SelectMarketViewAtHomeSheetPresentationController(with: reactor)
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
    
    private func presentToSelectArrivalMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String) -> FlowContributors {
        let reactor = SelectMarketAtHomeReactor(selectMarketFlow: .arrival, selectedMarketRelay: selectedMarketRelay, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        let viewController = SelectMarketViewAtHomeSheetPresentationController(with: reactor)
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
    
    private func goToAlarmSetting() -> FlowContributors {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .none
    }
    
    private func dismissSelectMarketViewController() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
