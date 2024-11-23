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
    private let favoritesUseCase: FavoritesUseCase
    let stepper: HomeStepper
    
    init(with rootViewController: UINavigationController, coinUseCase: CoinUseCase, alarmUseCase: AlarmUseCase, favoritesUseCase: FavoritesUseCase, stepper: HomeStepper) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.rootViewController.isNavigationBarHidden = true
        self.coinUseCase = coinUseCase
        self.alarmUseCase = alarmUseCase
        self.favoritesUseCase = favoritesUseCase
        self.stepper = stepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? HomeStep else { return .none }
        switch step {
            //MARK: 푸시
        case .navigateToHomeViewController:
            return navigateToHomeViewController()
        case .navigateToNotificationViewController:
            return navigateToNotificationViewController()
        case .navigateToDetailCoinInfoViewController(let market, let coin):
            return navigateToDetailCoinInfoViewController(market: market, coin: coin)
        case .navigateToSelectCoinAtDetailViewController(let market):
            return navigateToSelectCoinAtDetailViewController(market: market)
        case .navigateToEditFavoritesViewController:
            return navigateToEditFavoritesViewController()
            
            //MARK: 프레젠트
        case .presentToSelectDepartureMarketViewController(let selectedMarketRelay, let selectedMarketLocalizationKey):
            return presentToSelectDepartureMarketViewController(selectedMarketRelay: selectedMarketRelay, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        case .presentToSelectArrivalMarketViewController(let selectedMarketRelay, let selectedMarketLocalizationKey):
            return presentToSelectArrivalMarketViewController(selectedMarketRelay: selectedMarketRelay, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        case .presentToUnsavedFavoritesSheetPresentationController:
            return presentToUnsavedFavoritesSheetPresentationController()
        case .presentToUnsavedFavoritesSecondSheetPresentationController:
            return presentToUnsavedFavoritesSecondSheetPresentationController()
            
            //MARK: 설정앱 이동
        case .goToAlarmSetting:
            return goToAlarmSetting()
            
            //MARK: 뒤로가기
        case .dismiss:
            return dismiss()
        case .popViewController:
            return popViewController()
        case .dismissAndPopViewController:
            return dismissAndPopViewController()
            
            //MARK: 플로우 종료
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.completeMainFlow)
            
            //MARK: 프레젠트 공통 알람
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController(let message):
            return presentToUnknownErrorAlertController(message: message)
        case .presentToExpiredTokenErrorAlertController:
            return presentToExpiredTokenErrorAlertController()
        case .presentToAWSServerErrorAlertController:
            return presentToAWSServerErrorAlertController()
        }
    }
    
    //MARK: 푸시
    private func navigateToHomeViewController() -> FlowContributors {
        let priceReactor = PriceReactor(coinUseCase: self.coinUseCase, favoritesUseCase: self.favoritesUseCase)
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
        
        let infoReactor = InfoReactor(coinUseCase: self.coinUseCase, market: market, coin: coin)
        let infoViewController = InfoViewController(with: infoReactor)
        
        //let premiumReactor = PremiumReactor(coinUseCase: self.coinUseCase)
        let communityViewController = CommunityViewController()
        
        let reactor = DetailCoinInfoReactor(coinUseCase: self.coinUseCase, favoritesUseCase: self.favoritesUseCase, market: market, coin: coin)
        let viewController = DetailCoinInfoViewController(with: reactor, viewControllers: [chartViewController,infoViewController,communityViewController])
        viewController.hidesBottomBarWhenPushed = true
        let compositeStepper = CompositeStepper(steppers: [infoReactor, chartReactor, reactor])
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: compositeStepper))
    }
    
    private func navigateToSelectCoinAtDetailViewController(market: String) -> FlowContributors {
        let reactor = SelectCoinAtDetailReactor(coinUseCase: self.coinUseCase)
        let viewController = SelectCoinAtDetailViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToEditFavoritesViewController() -> FlowContributors {
        let reactor = EditFavoritesReactor(favoritesUseCase: self.favoritesUseCase)
        let viewController = EditFavoritesViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    //MARK: 프레젠트
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
    
    private func presentToUnsavedFavoritesSheetPresentationController() -> FlowContributors {
        let reactor = UnsavedFavoritesReactor()
        let viewController = UnsavedFavoritesSheetPresentationController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 208*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToUnsavedFavoritesSecondSheetPresentationController() -> FlowContributors {
        let reactor = UnsavedFavoritesSecondReactor()
        let viewController = UnsavedFavoritesSecondSheetPresentationController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 208*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    //MARK: 설정앱 이동
    private func goToAlarmSetting() -> FlowContributors {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .none
    }
    
    //MARK: 뒤로가기
    private func dismiss() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func dismissAndPopViewController() -> FlowContributors {
        self.rootViewController.dismiss(animated: true, completion: { [weak self] in
            self?.rootViewController.popViewController(animated: true)
        })
        
        return .none
    }
    
    //MARK: 프레젠트 공통 알람
    private func presentToNetworkErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "네트워크 오류"),
                                                message: LocalizationManager.shared.localizedString(forKey: "네트워크 오류 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToUnknownErrorAlertController(message: String) -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "알 수 없는 오류 발생"),
                                                message: LocalizationManager.shared.localizedString(forKey: "알 수 없는 오류 설명", arguments: message),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToExpiredTokenErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "로그인 만료"),
                                                message: LocalizationManager.shared.localizedString(forKey: "로그인 만료 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default) { [weak self] _ in
            self?.stepper.resetFlow()
        }
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToAWSServerErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "서버 오류"),
                                                message: LocalizationManager.shared.localizedString(forKey: "서버 오류 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
}
