import UIKit
import RxFlow

class SignupFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let signupUseCase = SignupUseCase(repository: SignupRepository())
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SignupStep else { return .none }
        switch step {
            //MARK: 푸시
        case .navigateToSignupEmailEntryViewController:
            return navigateToSignupEmailEntryViewController()
        case .navigateToSignupEmailVerificationNumberViewController:
            return navigateToSignupEmailVerificationNumberViewController()
        case .navigateToSignupPhoneNumberEntryViewController:
            return navigateToSignupPhoneNumberEntryViewController()
        case .navigateToTermsOfServiceViewController:
            return navigateToTermsOfServiceViewController()
        case .navigateToPrivacyPolicyViewController:
            return navigateToPrivacyPolicyViewController()
        case .navigateToMarketingConsentViewController:
            return navigateToMarketingConsentViewController()
        case .navigateToPhoneVerificationNumberViewController:
            return navigateToPhoneVerificationNumberViewController()
        case .navigateToSignupCompletedViewController:
            return navigateToSignupCompletedViewController()
            
            //MARK: 프레젠트
        case .presentToAgreeToTermsOfServiceViewController:
            return presentToAgreeToTermsOfServiceViewController()
        case .presentToAuthenticationNumberErrorAlertController:
            return presentToAuthenticationNumberErrorAlertController()
        case .presentToAlreadysubscribedNumberErrorAlertController:
            return presentToAlreadysubscribedNumberErrorAlertController()
            
            //MARK: 뒤로가기
        case .popViewController:
            return popViewController()
        case .popToRootViewController:
            return popToRootViewController()
        case .dismiss:
            return dismiss()
            
            //MARK: 플로우 종료
        case .completeSignupFlow:
            return completeSignupFlow()
            
            //MARK: 프레젠트 공통 알람
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController(let message):
            return presentToUnknownErrorAlertController(message: message)
        case .presentToAWSServerErrorAlertController:
            return presentToAWSServerErrorAlertController()
        }
    }
    
    //MARK: 푸시 메소드
    private func navigateToSignupEmailEntryViewController() -> FlowContributors {
        let reactor = SignupEmailEntryReactor(signupUseCase: signupUseCase)
        let viewController = SignupEmailEntryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSignupEmailVerificationNumberViewController() -> FlowContributors {
        let reactor = SignupEmailVerificationNumberReactor(signupUseCase: signupUseCase)
        let viewController = SignupEmailVerificationNumberViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSignupPhoneNumberEntryViewController() -> FlowContributors {
        let reactor = SignupPhoneNumberEntryReactor(signupUseCase: signupUseCase)
        let viewController = SignupPhoneNumberEntryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTermsOfServiceViewController() -> FlowContributors {
        let reactor = TermsOfServiceReactor(flowType: .signup)
        let viewController = TermsOfServiceViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPrivacyPolicyViewController() -> FlowContributors {
        let reactor = PrivacyPolicyReactor(flowType: .signup)
        let viewController = PrivacyPolicyViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToMarketingConsentViewController() -> FlowContributors {
        let reactor = MarketingConsentReactor(flowType: .signup)
        let viewController = MarketingConsentViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToPhoneVerificationNumberViewController() -> FlowContributors {
        let reactor = PhoneVerificationNumberReactor(signupUseCase: signupUseCase)
        let viewController = PhoneVerificationNumberViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSignupCompletedViewController() -> FlowContributors {
        let reactor = SignupCompletedReactor()
        let viewController = SignupCompletedViewController(with: reactor)
        self.rootViewController.navigationBar.isHidden = true
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    //MARK: 프레젠트 메소드
    private func presentToAgreeToTermsOfServiceViewController() -> FlowContributors {
        let reactor = AgreeToTermsOfServiceReactor(signupUseCase: signupUseCase)
        let viewController = AgreeToTermsOfServiceSheetPresentationController(with: reactor)
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
    
    private func presentToAuthenticationNumberErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
            message: LocalizationManager.shared.localizedString(forKey: "인증번호 불일치"),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToAlreadysubscribedNumberErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
            message: LocalizationManager.shared.localizedString(forKey: "가입된 번호"),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    //MARK: 뒤로가기 메소드
    private func dismiss() -> FlowContributors{
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func popToRootViewController() -> FlowContributors {
        
        return .end(forwardToParentFlowWithStep: AppStep.popToRootViewController)
    }
    
    //MARK: 플로우 종료 메소드
    private func completeSignupFlow() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: true)
        
        return .end(forwardToParentFlowWithStep: AppStep.completeSignupFlow)
    }
    
    //MARK: 프레젠트 공통 알람 메소드
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
