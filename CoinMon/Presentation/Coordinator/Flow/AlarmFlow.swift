import UIKit
import RxSwift
import RxFlow
import RxCocoa

class AlarmFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let coinUseCase: CoinUseCase
    private let indicatorUseCase: IndicatorUseCase
    private let alarmUseCase: AlarmUseCase
    private let purchaseUseCase: PurchaseUseCase
    let stepper: AlarmStepper
    
    init(with rootViewController: UINavigationController, coinUseCase: CoinUseCase, indicatorUseCase: IndicatorUseCase, alarmUseCase: AlarmUseCase, purchaseUseCase: PurchaseUseCase, stepper: AlarmStepper) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.coinUseCase = coinUseCase
        self.indicatorUseCase = indicatorUseCase
        self.alarmUseCase = alarmUseCase
        self.purchaseUseCase = purchaseUseCase
        self.stepper = stepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AlarmStep else { return .none }
        switch step {
        case .navigateToMainAlarmViewController:
            return navigateToMainAlarmViewController()
            
        case .navigateToSelectIndicatorViewController:
            return navigateToSelectIndicatorViewController()
        case .navigateToSelectCoinForIndicatorViewController(let flowType, let indicatorId, let indicatorName, let isPremium):
            return navigateToSelectCoinForIndicatorViewController(flowType: flowType, indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium)
        case .navigateToSelectCycleForIndicatorViewController(let flowType, let selectCycleForIndicatorFlowType, let indicatorId, let frequency, let targets, let indicatorName, let isPremium):
            return navigateToSelectCycleForIndicatorViewController(flowType: flowType, selectCycleForIndicatorFlowType: selectCycleForIndicatorFlowType, indicatorId: indicatorId, frequency: frequency, targets: targets, indicatorName: indicatorName, isPremium: isPremium)
        case .navigateToDetailIndicatorViewController(let flowType, let indicatorId, let indicatorName, let isPremium, let frequency):
            return navigateToDetailIndicatorViewController(flowType: flowType, indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium, frequency: frequency)
        case .navigateToDetailIndicatorCoinViewController(let indicatorId, let indicatorCoinId, let coin, let price, let indicatorName, let frequency):
            return navigateToDetailIndicatorCoinViewController(indicatorId: indicatorId, indicatorCoinId: indicatorCoinId, coin: coin, price: price, indicatorName: indicatorName, frequency: frequency)
        case .navigateToUpdateIndicatorCoinViewController(let indicatorId, let indicatorName, let frequency):
            return navigateToUpdateIndicatorCoinViewController(indicatorId: indicatorId, indicatorName: indicatorName, frequency: frequency)
        case .navigateToSelectCoinForUpdateIndicatorViewController(let indicatorId, let indicatorName, let isPremium, let selectCoinRelay):
            return navigateToSelectCoinForUpdateIndicatorViewController(indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium, selectCoinRelay: selectCoinRelay)
            
        case .navigateToAddAlarmViewController:
            return navigateToAddAlarmViewController()
        case .navigateToModifyAlarmViewController(let market, let alarm):
            return navigateToModifyAlarmViewController(market: market, alarm: alarm)
            
            // 테스트 알림
        case .presentToIsReceivedTestAlarmViewController:
            return presentToIsReceivedTestAlarmViewController()
        case .presentToIsNotSetTestAlarmViewController:
            return presentToIsNotSetTestAlarmViewController()
        case .presentToResendTestAlarmViewController:
            return presentToResendTestAlarmViewController()
            
        case .presentToIsRealPopViewController:
            return presentToIsRealPopViewController()
            
        case .presentToExplainIndicatorSheetPresentationController(let indicatorId):
            return presentToExplainIndicatorSheetPresentationController(indicatorId: indicatorId)
        case .presentToDeleteIndicatorPushSheetPresentationController(let indicatorId, let indicatorName, let flowType):
            return presentToDeleteIndicatorPushSheetPresentationController(indicatorId: indicatorId, indicatorName: indicatorName, flowType: flowType)
        case .presentToMoreButtonAtIndicatorSheetPresentationController(let indicatorId, let indicatorName, let frequency):
            return presentToMoreButtonAtIndicatorSheetPresentationController(indicatorId: indicatorId, indicatorName: indicatorName, frequency: frequency)
            
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
        case .presentToUnknownErrorAlertController(let message):
            return presentToUnknownErrorAlertController(message: message)
        case .presentToExpiredTokenErrorAlertController:
            return presentToExpiredTokenErrorAlertController()
        case .presentToAWSServerErrorAlertController:
            return presentToAWSServerErrorAlertController()
            
        case .goToPurchaseFlow:
            return goToPurchaseFlow()
            
        case .goToAlarmSetting:
            return goToAlarmSetting()
        case .goToKakaoOpenURL(let url, let fallbackUrl):
            return goToKakaoOpenURL(url: url, fallbackUrl: fallbackUrl)
            
        case .dismissSheetPresentationController:
            return dismissSheetPresentationController()
        case .popViewController:
            return popViewController()
        case .popToRootViewController:
            return popToRootViewController()
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.completeMainFlow)
        }
    }
    
    private func navigateToMainAlarmViewController() -> FlowContributors {
        let indicatorReactor = IndicatorReactor(indicatorUseCase: self.indicatorUseCase, purchaseUseCase: self.purchaseUseCase)
        let indicatorViewController = IndicatorViewController(with: indicatorReactor)
        
        let alarmReactor = AlarmReactor(alarmUseCase: self.alarmUseCase)
        let alarmViewController = AlarmViewController(with: alarmReactor)
        
        let reactor = MainAlarmReactor()
        let viewController = MainAlarmViewController(with: reactor, viewControllers: [indicatorViewController,alarmViewController])
        let compositeStepper = CompositeStepper(steppers: [indicatorReactor, alarmReactor, reactor])
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: compositeStepper))
    }
    
    private func navigateToSelectIndicatorViewController() -> FlowContributors {
        let reactor = SelectIndicatorReactor(indicatorUseCase: self.indicatorUseCase, purchaseUseCase: self.purchaseUseCase)
        let viewController = SelectIndicatorViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSelectCoinForIndicatorViewController(flowType: FlowType, indicatorId: String, indicatorName: String, isPremium: Bool) -> FlowContributors {
        let reactor = SelectCoinForIndicatorReactor(flowType: flowType, indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium)
        let viewController = SelectCoinForIndicatorViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSelectCycleForIndicatorViewController(flowType: FlowType, selectCycleForIndicatorFlowType: SelectCycleForIndicatorFlowType, indicatorId: String, frequency: String, targets: [String], indicatorName: String, isPremium: Bool) -> FlowContributors {
        let reactor = SelectCycleForIndicatorReactor(flowType: flowType, selectCycleForIndicatorFlowType: selectCycleForIndicatorFlowType, indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, frequency: frequency, targets: targets, indicatorName: indicatorName, isPremium: isPremium)
        let viewController = SelectCycleForIndicatorViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToDetailIndicatorViewController(flowType: String, indicatorId: String, indicatorName: String, isPremium: Bool, frequency: String) -> FlowContributors {
        let reactor = DetailIndicatorReactor(indicatorUseCase: self.indicatorUseCase, flowType: flowType, indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium, frequency: frequency)
        let viewController = DetailIndicatorViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToDetailIndicatorCoinViewController(indicatorId: String, indicatorCoinId: String, coin: String, price: String, indicatorName: String, frequency: String) -> FlowContributors {
        let detailIndicatorCoinChartReactor = DetailIndicatorCoinChartReactor(market: "BINANCE", coin: coin)
        let detailIndicatorCoinChartViewController = DetailIndicatorCoinChartViewController(with: detailIndicatorCoinChartReactor)
        
        let detailIndicatorCoinHistoryReactor = DetailIndicatorCoinHistoryReactor(indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, indicatorCoinId: indicatorCoinId)
        let detailIndicatorCoinHistoryViewController = DetailIndicatorCoinHistoryViewController(with: detailIndicatorCoinHistoryReactor)
        
        let reactor = DetailIndicatorCoinReactor(indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, indicatorCoinId: indicatorCoinId, coin: coin, price: price, indicatorName: indicatorName, frequency: frequency)
        let viewController = DetailIndicatorCoinViewController(with: reactor, viewControllers: [detailIndicatorCoinChartViewController,detailIndicatorCoinHistoryViewController])
        let compositeStepper = CompositeStepper(steppers: [detailIndicatorCoinChartReactor, detailIndicatorCoinHistoryReactor, reactor])
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: compositeStepper))
    }
    
    private func navigateToUpdateIndicatorCoinViewController(indicatorId: String, indicatorName: String, frequency: String) -> FlowContributors {
        let reactor = UpdateIndicatorCoinReactor(indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, indicatorName: indicatorName, frequency: frequency)
        let viewController = UpdateIndicatorCoinViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSelectCoinForUpdateIndicatorViewController(indicatorId: String, indicatorName: String, isPremium: Bool, selectCoinRelay: BehaviorRelay<[UpdateSelectedIndicatorCoin]>) -> FlowContributors {
        let reactor = SelectCoinForUpdateIndicatorReactor(indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium, selectCoinRelay: selectCoinRelay)
        let viewController = SelectCoinForUpdateIndicatorViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    // 지정가 알림
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
    
    private func presentToIsRealPopViewController() -> FlowContributors {
        let reactor = IsRealPopReactor(flowType: .alarm)
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
    
    // 테스트 알림
    private func presentToIsReceivedTestAlarmViewController() -> FlowContributors {
        let reactor = IsReceivedTestAlarmReactor()
        let viewController = IsReceivedTestAlarmViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 345*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToIsNotSetTestAlarmViewController() -> FlowContributors {
        let reactor = IsNotSetTestAlarmReactor()
        let viewController = IsNotSetTestAlarmViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 345*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToResendTestAlarmViewController() -> FlowContributors {
        let reactor = ResendTestAlarmReactor(indicatorUseCase: self.indicatorUseCase)
        let viewController = ResendTestAlarmViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 318*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToExplainIndicatorSheetPresentationController(indicatorId: String) -> FlowContributors {
        let reactor = ExplainIndicatorSheetPresentationReactor(indicatorId: indicatorId)
        let viewController = ExplainIndicatorSheetPresentationController(with: reactor)
        viewController.heightRelay
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] contentHeight in
                if let sheet = viewController.sheetPresentationController {
                    let customDetent = UISheetPresentationController.Detent.custom { context in
                        return contentHeight
                    }
                    
                    sheet.detents = [customDetent]
                    sheet.prefersGrabberVisible = false
                    sheet.preferredCornerRadius = 16 * ConstantsManager.standardHeight
                }
                
                self?.rootViewController.present(viewController, animated: true)
            })
            .disposed(by: viewController.disposeBag)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToDeleteIndicatorPushSheetPresentationController(indicatorId: String, indicatorName: String, flowType: String) -> FlowContributors {
        let reactor = DeleteIndicatorPushSheetPresentationReactor(indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, indicatorName: indicatorName, flowType: flowType)
        let viewController = DeleteIndicatorPushSheetPresentationController(with: reactor)
        viewController.heightRelay
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] contentHeight in                
                if let sheet = viewController.sheetPresentationController {
                    let customDetent = UISheetPresentationController.Detent.custom { context in
                        return contentHeight
                    }
                    
                    sheet.detents = [customDetent]
                    sheet.prefersGrabberVisible = false
                    sheet.preferredCornerRadius = 16 * ConstantsManager.standardHeight
                }
                
                self?.rootViewController.present(viewController, animated: true)
            })
            .disposed(by: viewController.disposeBag)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToMoreButtonAtIndicatorSheetPresentationController(indicatorId: String, indicatorName: String, frequency: String) -> FlowContributors {
        let reactor = MoreButtonAtIndicatorSheetPresentationReactor(indicatorUseCase: self.indicatorUseCase, indicatorId: indicatorId, indicatorName: indicatorName, frequency: frequency)
        let viewController = MoreButtonAtIndicatorSheetPresentationController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 192*ConstantsManager.standardHeight
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16*ConstantsManager.standardHeight
        }
        self.rootViewController.present(viewController, animated: true)
        
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
    
    private func goToPurchaseFlow() -> FlowContributors {
        let purchaseStepper = PurchaseStepper()
        let purchaseFlow = PurchaseFlow(with: self.rootViewController, indicatorUseCase: self.indicatorUseCase, purchaseUseCase: self.purchaseUseCase, stepper: purchaseStepper)
        
        return .one(flowContributor: .contribute(withNextPresentable: purchaseFlow, withNextStepper: purchaseStepper))
    }
    
    private func goToAlarmSetting() -> FlowContributors {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .none
    }
    
    private func goToKakaoOpenURL(url: String, fallbackUrl: String) -> FlowContributors {
        let url = URL(string: url)!
        let fallbackUrl = URL(string: fallbackUrl)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(fallbackUrl, options: [:], completionHandler: nil)
        }
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
    
    private func popToRootViewController() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        
        return .none
    }
}
