import UIKit
import RxFlow

class SigninFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    private let signinUseCase = SigninUseCase(repository: SigninRepository())
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SigninStep else { return .none }
        switch step {
            //MARK: 푸시
        case .navigateToSigninEmailEntryViewController:
            return navigateToSigninEmailEntryViewController()
        case .navigateToSigninEmailVerificationNumberViewController:
            return navigateToSigninEmailVerificationNumberViewController()
            
            //MARK: 프레젠트
        case .presentToAuthenticationNumberErrorAlertController:
            return presentToAuthenticationNumberErrorAlertController()
        case .presentToNoRegisteredEmailErrorAlertController:
            return presentToNoRegisteredEmailErrorAlertController()
            
            //MARK: 뒤로가기
        case .popViewController:
            return popViewController()
        case .popToRootViewController:
            return popToRootViewController()
            
            //MARK: 플로우 종료
        case .completeSigninFlow:
            return completeSigninFlow()
            
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
    private func navigateToSigninEmailEntryViewController() -> FlowContributors {
        let reactor = SigninEmailEntryReactor(signinUseCase: signinUseCase)
        let viewController = SigninEmailEntryViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSigninEmailVerificationNumberViewController() -> FlowContributors {
        let reactor = SigninEmailVerificationNumberReactor(signinUseCase: signinUseCase)
        let viewController = SigninEmailVerificationNumberViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    //MARK: 프레젠트 메소드
    private func presentToAuthenticationNumberErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
            message: LocalizationManager.shared.localizedString(forKey: "인증번호 불일치"),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func presentToNoRegisteredEmailErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: nil,
            message: LocalizationManager.shared.localizedString(forKey: "이메일 없음"),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.view.accessibilityIdentifier = "NoRegisteredEmailErrorAlertController"
        okAction.accessibilityIdentifier = "NoRegisteredEmailErrorAlertControllerOKButton"
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    //MARK: 뒤로가기 메소드
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func popToRootViewController() -> FlowContributors {
        
        return .end(forwardToParentFlowWithStep: AppStep.popToRootViewController)
    }
    
    //MARK: 플로우 종료 메소드
    private func completeSigninFlow() -> FlowContributors {
        self.rootViewController.popToRootViewController(animated: false)

        return .end(forwardToParentFlowWithStep: AppStep.completeSigninFlow)
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
