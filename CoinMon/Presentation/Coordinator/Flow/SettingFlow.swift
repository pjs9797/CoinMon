import UIKit
import RxFlow

class SettingFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let userUseCase: UserUseCase
    private let indicatorUseCase: IndicatorUseCase
    private let purchaseUseCase: PurchaseUseCase
    let stepper: SettingStepper
    
    init(with rootViewController: UINavigationController, userUseCase: UserUseCase, indicatorUseCase: IndicatorUseCase, purchaseUseCase: PurchaseUseCase, stepper: SettingStepper) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.userUseCase = userUseCase
        self.indicatorUseCase = indicatorUseCase
        self.purchaseUseCase = purchaseUseCase
        self.stepper = stepper
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SettingStep else { return .none }
        switch step {
            //MARK: 푸시
        case .navigateToSettingViewController:
            return navigateToSettingViewController()
        case .navigateToMyAccountViewController:
            return navigateToMyAccountViewController()
        case .navigateToInquiryViewController:
            return navigateToInquiryViewController()
        case .navigateToWithdrawalViewController:
            return navigateToWithdrawalViewController()
        case .navigateToTermsOfServiceViewController:
            return navigateToTermsOfServiceViewController()
        case .navigateToPrivacyPolicyViewController:
            return navigateToPrivacyPolicyViewController()
        case .navigateToSuccessSubscriptionViewController:
            return navigateToSuccessSubscriptionViewController()
        case .navigateToSubscriptionManagementViewController:
            return navigateToSubscriptionManagementViewController()
            
            //MARK: 프레젠트
        case .presentToDuplicatedNicknameErrorAlertController:
            return presentToDuplicatedNicknameErrorAlertController()
        case .presentToLogoutAlertController(let reactor):
            return presentToLogoutAlertController(reactor: reactor)
        case .presentToWithdrawAlertController(let reactor):
            return presentToWithdrawAlertController(reactor: reactor)
            
            //MARK: 플로우 이동
        case .goToPurchaseFlow:
            return goToPurchaseFlow()
            
            //MARK: 설정앱 이동
        case .goToAlarmSetting:
            return goToAlarmSetting()
            
            //MARK: URL 이동
        case .goToOpenURL(let url, let fallbackUrl):
            return goToOpenURL(url: url, fallbackUrl: fallbackUrl)
            
            //MARK: 뒤로가기
        case .popDownWithAnimation:
            return popDownWithAnimation()
        case .popViewController:
            return popViewController()
            
            //MARK: 플로우 종료
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.completeMainFlow)
        case .endFlowAfterWithdrawal:
            return .end(forwardToParentFlowWithStep: AppStep.completeMainFlowAfterWithdrawal)
            
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
    private func navigateToSettingViewController() -> FlowContributors {
        let reactor = SettingReactor(flowType: .setting, userUseCase: self.userUseCase, purchaseUseCase: self.purchaseUseCase)
        let viewController = SettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToMyAccountViewController() -> FlowContributors {
        let reactor = MyAccountReactor(userUseCase: self.userUseCase)
        let viewController = MyAccountViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToInquiryViewController() -> FlowContributors {
        let reactor = InquiryReactor()
        let viewController = InquiryViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToWithdrawalViewController() -> FlowContributors {
        let reactor = WithdrawalReactor(userUseCase: self.userUseCase)
        let viewController = WithdrawalViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTermsOfServiceViewController() -> FlowContributors {
        let reactor = TermsOfServiceReactor(flowType: .setting)
        let viewController = TermsOfServiceViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPrivacyPolicyViewController() -> FlowContributors {
        let reactor = PrivacyPolicyReactor(flowType: .setting)
        let viewController = PrivacyPolicyViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSuccessSubscriptionViewController() -> FlowContributors {
        let reactor = SuccessSubscriptionReactor(flowType: .setting, purchaseUseCase: self.purchaseUseCase)
        let viewController = SuccessSubscriptionViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = false
        self.rootViewController.pushUpWithAnimation(viewController: viewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSubscriptionManagementViewController() -> FlowContributors {
        let reactor = SubscriptionManagementReactor(flowType: .setting, purchaseUseCase: self.purchaseUseCase)
        let viewController = SubscriptionManagementViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    //MARK: 프레젠트
    private func presentToDuplicatedNicknameErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
                                                message: LocalizationManager.shared.localizedString(forKey: "중복되는 닉네임이에요"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToLogoutAlertController(reactor: MyAccountReactor) -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
                                                message: LocalizationManager.shared.localizedString(forKey: "로그아웃알림"),
                                                preferredStyle: .alert)
        let noAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "아니요"), style: .default, handler: nil)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "네"), style: .default) { _ in
            reactor.action.onNext(.logoutAlertYesButtonTapped)
        }
        alertController.addAction(noAction)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)

        return .none
    }
    
    private func presentToWithdrawAlertController(reactor: WithdrawalReactor) -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "탈퇴알림"),
                                                message: LocalizationManager.shared.localizedString(forKey: "코인몬을 이용해 주셔서 감사합니다."),
                                                preferredStyle: .alert)
        let noAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "아니요"), style: .default, handler: nil)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default) { _ in
            reactor.action.onNext(.withdrawAlertOkButtonTapped)
        }
        alertController.addAction(noAction)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    //MARK: 플로우 이동
    private func goToPurchaseFlow() -> FlowContributors {
        let purchaseStepper = PurchaseStepper()
        let purchaseFlow = PurchaseFlow(with: self.rootViewController, indicatorUseCase: self.indicatorUseCase, purchaseUseCase: self.purchaseUseCase, stepper: purchaseStepper)
        
        return .one(flowContributor: .contribute(withNextPresentable: purchaseFlow, withNextStepper: purchaseStepper))
    }
    
    //MARK: 설정앱 이동
    private func goToAlarmSetting() -> FlowContributors {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        return .none
    }
    
    //MARK: URL 이동
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
    
    //MARK: 뒤로가기
    private func popDownWithAnimation() -> FlowContributors {
        self.rootViewController.popDownWithAnimation()
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
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
