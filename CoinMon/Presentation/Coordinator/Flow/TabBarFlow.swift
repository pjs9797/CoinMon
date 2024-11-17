import UIKit
import RxFlow
import RxSwift

class TabBarFlow: Flow {
    var root: Presentable {
        return self.tabBarController
    }
    
    private var rootViewController: UINavigationController
    private let tabBarController: TabBarController
    private let indicatorUseCase: IndicatorUseCase
    private let purchaseUseCase: PurchaseUseCase
    
    init(with rootViewController: UINavigationController, tabBarController: TabBarController, purchaseUseCase: PurchaseUseCase, indicatorUseCase: IndicatorUseCase) {
        self.rootViewController = rootViewController
        self.rootViewController.isNavigationBarHidden = true
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.tabBarController = tabBarController
        self.purchaseUseCase = purchaseUseCase
        self.indicatorUseCase = indicatorUseCase
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TabBarStep else { return .none }
        switch step {
            //MARK: 푸시
        case .navigateToTryNewIndicatorViewController:
            return navigateToTryNewIndicatorViewController()
            
            //MARK: 프레젠트
        case .presentToNewIndicatorViewController:
            return presentToNewIndicatorViewController()
        case .presentToExplainIndicatorSheetPresentationController(let indicatorId):
            return presentToExplainIndicatorSheetPresentationController(indicatorId: indicatorId)
            
            //MARK: 뒤로가기
        case .dismiss:
            return dismiss()
        case .popDownWithAnimation:
            return popDownWithAnimation()
            
            //MARK: 플로우 이동
        case .goToPurchaseFlow:
            return goToPurchaseFlow()
        }
    }
    
    //MARK: 푸시 메소드
    private func navigateToTryNewIndicatorViewController() -> FlowContributors {
        let reactor = TryNewIndicatorReactor()
        let viewController = TryNewIndicatorViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushUpWithAnimation(viewController: viewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    //MARK: 프레젠트 메소드
    private func presentToNewIndicatorViewController() -> FlowContributors {
        let reactor = NewIndicatorReactor()
        let viewController = NewIndicatorViewController(with: reactor)
        if let sheet = viewController.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                return 324*ConstantsManager.standardHeight
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
    
    //MARK: 뒤로가기 메소드
    private func dismiss() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func popDownWithAnimation() -> FlowContributors {
        self.rootViewController.popDownWithAnimation()
        
        return .none
    }
    
    //MARK: 플로우 이동 메소드
    private func goToPurchaseFlow() -> FlowContributors {
        let purchaseStepper = PurchaseStepper()
        let purchaseFlow = PurchaseFlow(with: self.rootViewController, indicatorUseCase: self.indicatorUseCase, purchaseUseCase: self.purchaseUseCase, stepper: purchaseStepper)
        
        return .one(flowContributor: .contribute(withNextPresentable: purchaseFlow, withNextStepper: purchaseStepper))
    }
}
