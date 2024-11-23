import UIKit
import RxFlow

class PurchaseFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let indicatorUseCase: IndicatorUseCase
    private let purchaseUseCase: PurchaseUseCase
    private let stepper: PurchaseStepper
    
    init(with rootViewController: UINavigationController, indicatorUseCase: IndicatorUseCase, purchaseUseCase: PurchaseUseCase, stepper: PurchaseStepper) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.indicatorUseCase = indicatorUseCase
        self.purchaseUseCase = purchaseUseCase
        self.stepper = stepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PurchaseStep else { return .none }
        switch step {
        case .navigateToTryNewIndicatorViewController:
            return navigateToTryNewIndicatorViewController()
        case .navigateToPurchaseViewController:
            return navigateToPurchaseViewController()
        case .navigateToSuccessSubscriptionViewController:
            return navigateToSuccessSubscriptionViewController()
        case .navigateToSubscriptionManagementViewController:
            return navigateToSubscriptionManagementViewController()
            
        case .navigateToSelectCoinForIndicatorViewController(let flowType, let indicatorId, let indicatorName, let isPremium):
            return navigateToSelectCoinForIndicatorViewController(flowType: flowType, indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium)
        case .navigateToSelectCycleForIndicatorViewController(let flowType, let selectCycleForIndicatorFlowType, let indicatorId, let frequency, let targets, let indicatorName, let isPremium):
            return navigateToSelectCycleForIndicatorViewController(selectCycleForIndicatorFlowType: selectCycleForIndicatorFlowType, flowType: flowType, indicatorId: indicatorId, frequency: frequency, targets: targets, indicatorName: indicatorName, isPremium: isPremium)
            
        case .presentToIsRealPopViewController:
            return presentToIsRealPopViewController()
            
        case .presentToSuccessPurchaseAlertController:
            return presentToSuccessPurchaseAlertController()
        case .presentToFailurePurchaseAlertController:
            return presentToFailurePurchaseAlertController()
        case .presentToServerFailurePurchaseAlertController:
            return presentToServerFailurePurchaseAlertController()
            
            // 프레젠트 공통 알람
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController(let message):
            return presentToUnknownErrorAlertController(message: message)
        case .presentToExpiredTokenErrorAlertController:
            return presentToExpiredTokenErrorAlertController()
        case .presentToAWSServerErrorAlertController:
            return presentToAWSServerErrorAlertController()
            
        case .goToAlarmSetting:
            return goToAlarmSetting()
        case .goToOpenURL(let url, let fallbackUrl):
            return goToOpenURL(url: url, fallbackUrl: fallbackUrl)
            
        case .dismiss:
            return dismiss()
        case .popWithCustomAnimation:
            return popWithCustomAnimation()
        case .popViewController:
            return popViewController()
        case .popToRootViewController:
            return popToRootViewController()
            
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.completeMainFlow)
        }
    }
    
    private func navigateToTryNewIndicatorViewController() -> FlowContributors {
        let reactor = TryNewIndicatorReactor()
        let viewController = TryNewIndicatorViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = false
        self.rootViewController.pushUpWithAnimation(viewController: viewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPurchaseViewController() -> FlowContributors {
        let reactor = PurchaseReactor(purchaseUseCase: self.purchaseUseCase)
        let viewController = PurchaseViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = false
        self.rootViewController.pushUpWithAnimation(viewController: viewController)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSuccessSubscriptionViewController() -> FlowContributors {
        let reactor = SuccessSubscriptionReactor(flowType: .purchase, purchaseUseCase: self.purchaseUseCase)
        let viewController = SuccessSubscriptionViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = false
        self.rootViewController.pushUpWithAnimation(viewController: viewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSubscriptionManagementViewController() -> FlowContributors {
        let reactor = SubscriptionManagementReactor(flowType: .purchase, purchaseUseCase: self.purchaseUseCase)
        let viewController = SubscriptionManagementViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSelectCoinForIndicatorViewController(flowType: FlowType, indicatorId: String, indicatorName: String, isPremium: Bool) -> FlowContributors {
        let reactor = SelectCoinForIndicatorReactor(flowType: flowType, indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium)
        let viewController = SelectCoinForIndicatorViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSelectCycleForIndicatorViewController(selectCycleForIndicatorFlowType: SelectCycleForIndicatorFlowType, flowType: FlowType, indicatorId: String, frequency: String, targets: [String], indicatorName: String, isPremium: Bool) -> FlowContributors {
        let reactor = SelectCycleForIndicatorReactor(flowType: flowType, selectCycleForIndicatorFlowType: selectCycleForIndicatorFlowType, indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, frequency: frequency, targets: targets, indicatorName: indicatorName, isPremium: isPremium)
        let viewController = SelectCycleForIndicatorViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToIsRealPopViewController() -> FlowContributors {
        let reactor = IsRealPopReactor(flowType: .purchase)
        let viewController = IsRealPopViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 187*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToSuccessPurchaseAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "구독 완료"),
                                                       message: LocalizationManager.shared.localizedString(forKey: "성공적으로 구독 되었습니다"),
                                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToFailurePurchaseAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "다시 시도해 주세요"),
                                                       message: LocalizationManager.shared.localizedString(forKey: "구독이 완료 되지 않았습니다"),
                                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToServerFailurePurchaseAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "문의해주세요"),
                                                       message: LocalizationManager.shared.localizedString(forKey: "결제에 오류가 발생했습니다."),
                                                       preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    // 프레젠트 공통 알람
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
    
    private func goToAlarmSetting() -> FlowContributors {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .none
    }
    
    private func goToOpenURL(url: String, fallbackUrl: String) -> FlowContributors {
        let url = URL(string: url)!
        let fallbackUrl = URL(string: fallbackUrl)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(fallbackUrl, options: [:], completionHandler: nil)
        }
        return .none
    }
    
    private func dismiss() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        return .none
    }
    
    private func popWithCustomAnimation() -> FlowContributors {
        self.rootViewController.popDownWithAnimation()
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func popToRootViewController() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        
        return .none
    }
}
