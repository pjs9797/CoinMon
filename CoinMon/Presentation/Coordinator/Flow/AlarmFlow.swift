import UIKit
import RxFlow
import RxCocoa

class AlarmFlow: Flow {
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
        self.coinUseCase = coinUseCase
        self.alarmUseCase = alarmUseCase
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AlarmStep else { return .none }
        switch step {
        case .navigateToAlarmViewController:
            return navigateToAlarmViewController()
        case .navigateToAddAlarmViewController:
            return navigateToAddAlarmViewController()
        case .navigateToModifyAlarmViewController(let market, let alarm):
            return navigateToModifyAlarmViewController(market: market, alarm: alarm)
        case .presentToSelectMarketViewController(let selectedMarketRelay, let selectedMarketLocalizationKey):
            return presentToSelectMarketViewController(selectedMarketRelay: selectedMarketRelay, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        case .navigateToSelectCoinViewController(let selectedCoinRelay, let market):
            return navigateToSelectCoinViewController(selectedCoinRelay: selectedCoinRelay, market: market)
        case .presentToSelectFirstAlarmConditionViewController(let firstAlarmConditionRelay):
            return presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: firstAlarmConditionRelay)
        case .presentToSelectSecondAlarmConditionViewController(let secondAlarmConditionRelay):
            return presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: secondAlarmConditionRelay)
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToRestrictedAlarmErrorAlertController:
            return presentToRestrictedAlarmErrorAlertController()
        case .dismissSheetPresentationController:
            return dismissSheetPresentationController()
        case .popViewController:
            return popViewController()
        }
    }
    
    private func navigateToAlarmViewController() -> FlowContributors {
        let reactor = AlarmReactor(alarmUseCase: self.alarmUseCase)
        let viewController = AlarmViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToAddAlarmViewController() -> FlowContributors {
        let reactor = AddAlarmReactor(alarmUseCase: self.alarmUseCase)
        let viewController = AddAlarmViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToModifyAlarmViewController(market: String, alarm: Alarm) -> FlowContributors {
        let reactor = ModifyAlarmReactor(alarmUseCase: self.alarmUseCase, coinUseCase: self.coinUseCase, market: market, alarm: alarm)
        let viewController = ModifyAlarmViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectMarketViewController(selectedMarketRelay: PublishRelay<String>, selectedMarketLocalizationKey: String) -> FlowContributors {
        let reactor = SelectMarketAtAlarmReactor(selectedMarketRelay: selectedMarketRelay, selectedMarketLocalizationKey: selectedMarketLocalizationKey)
        let viewController = SelectMarketAtAlarmSheetPresentationController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 348*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSelectCoinViewController(selectedCoinRelay: PublishRelay<(String,String)>, market: String) -> FlowContributors {
        let reactor = SelectCoinAtAlarmReactor(coinUseCase: self.coinUseCase, selectedCoinRelay: selectedCoinRelay, market: market)
        let viewController = SelectCoinViewAtAlarmController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: PublishRelay<Int>) -> FlowContributors {
        let reactor = SelectFirstAlarmConditionReactor(firstAlarmConditionRelay: firstAlarmConditionRelay)
        let viewController = SelectFirstAlarmConditionSheetPresentationController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 348*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectSecondAlarmConditionReactor(secondAlarmConditionRelay: secondAlarmConditionRelay)
        let viewController = SelectSecondAlarmConditionSheetPresentationController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 348*ConstantsManager.standardHeight
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
    
    private func presentToRestrictedAlarmErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
                                                message: LocalizationManager.shared.localizedString(forKey: "알람 제한"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func dismissSheetPresentationController() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
