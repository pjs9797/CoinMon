import UIKit
import RxFlow
import RxCocoa

class AlarmFlow: Flow {
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
        guard let step = step as? AlarmStep else { return .none }
        switch step {
        case .navigateToAlarmViewController:
            return navigateToAlarmViewController()
        case .navigateToAddAlarmViewController:
            return navigateToAddAlarmViewController()
        case .presentToSelectMarketViewController(let selectedMarketRelay):
            return presentToSelectMarketViewController(selectedMarketRelay: selectedMarketRelay)
        case .navigateToSelectCoinViewController(let selectedCoinRelay):
            return navigateToSelectCoinViewController(selectedCoinRelay: selectedCoinRelay)        case .presentToSelectFirstAlarmConditionViewController(let firstAlarmConditionRelay):
            return presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: firstAlarmConditionRelay)
        case .presentToSelectSecondAlarmConditionViewController(let secondAlarmConditionRelay):
            return presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: secondAlarmConditionRelay)
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .dismissSheetPresentationController:
            return dismissSheetPresentationController()
        case .popViewController:
            return popViewController()
        }
    }
    
    private func navigateToAlarmViewController() -> FlowContributors {
        let reactor = AlarmReactor()
        let viewController = AlarmViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToAddAlarmViewController() -> FlowContributors {
        let reactor = AddAlarmReactor()
        let viewController = AddAlarmViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectMarketViewController(selectedMarketRelay: PublishRelay<String>) -> FlowContributors {
        let reactor = SelectMarketAtAlarmReactor( selectedMarketRelay: selectedMarketRelay)
        let viewController = SelectMarketAtAlarmViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 348*Constants.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*Constants.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSelectCoinViewController(selectedCoinRelay: PublishRelay<(String,String)>) -> FlowContributors {
        let reactor = SelectCoinReactor(selectedCoinRelay: selectedCoinRelay)
        let viewController = SelectCoinViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: PublishRelay<Int>) -> FlowContributors {
        let reactor = SelectFirstAlarmConditionReactor(firstAlarmConditionRelay: firstAlarmConditionRelay)
        let viewController = SelectFirstAlarmConditionViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 348*Constants.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*Constants.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: PublishRelay<Int>) -> FlowContributors {
        let reactor = SelectSecondAlarmConditionReactor(secondAlarmConditionRelay: secondAlarmConditionRelay)
        let viewController = SelectSecondAlarmConditionViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 348*Constants.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*Constants.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToNetworkErrorAlertController() -> FlowContributors {
        let alertController = UIAlertController(title: LocalizationManager.shared.localizedString(forKey: "네트워크 오류"),
                                                message: LocalizationManager.shared.localizedString(forKey: "네트워크 오류 설명"),
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
