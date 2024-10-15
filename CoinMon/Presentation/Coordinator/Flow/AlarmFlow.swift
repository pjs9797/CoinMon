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
    private let stepper: AlarmStepper
    
    init(with rootViewController: UINavigationController, coinUseCase: CoinUseCase, alarmUseCase: AlarmUseCase, stepper: AlarmStepper) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.coinUseCase = coinUseCase
        self.alarmUseCase = alarmUseCase
        self.stepper = stepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AlarmStep else { return .none }
        switch step {
        case .navigateToMainAlarmViewController:
            return navigateToMainAlarmViewController()
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
        case .presentToRestrictedAlarmErrorAlertController:
            return presentToRestrictedAlarmErrorAlertController()
            
            // 프레젠트 공통 알람
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController:
            return presentToUnknownErrorAlertController()
        case .presentToExpiredTokenErrorAlertController:
            return presentToExpiredTokenErrorAlertController()
        case .presentToAWSServerErrorAlertController:
            return presentToAWSServerErrorAlertController()
            
        case .dismissSheetPresentationController:
            return dismissSheetPresentationController()
        case .popViewController:
            return popViewController()
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.completeMainFlow)
        }
    }
    
    private func navigateToMainAlarmViewController() -> FlowContributors {
        let indicatorReactor = IndicatorReactor()
        let indicatorViewController = IndicatorViewController(with: indicatorReactor)
        
        let alarmReactor = AlarmReactor(alarmUseCase: self.alarmUseCase)
        let alarmViewController = AlarmViewController(with: alarmReactor)
        
        let reactor = MainAlarmReactor()
        let viewController = MainAlarmViewController(with: reactor, viewControllers: [indicatorViewController,alarmViewController])
        let compositeStepper = CompositeStepper(steppers: [indicatorReactor, alarmReactor, reactor])
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: compositeStepper))
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
    
    private func presentToRestrictedAlarmErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
                                                message: LocalizationManager.shared.localizedString(forKey: "알람 제한"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
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
    
    private func presentToUnknownErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "알 수 없는 오류 발생"),
                                                message: LocalizationManager.shared.localizedString(forKey: "알 수 없는 오류 설명"),
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
    
    private func dismissSheetPresentationController() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
}
