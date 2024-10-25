import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let coinUseCase = CoinUseCase(repository: CoinRepository())
    private let indicatorUseCase = IndicatorUseCase(repository: IndicatorRepository())
    private let alarmUseCase = AlarmUseCase(repository: AlarmRepository())
    private let userUseCase = UserUseCase(repository: UserRepository())
    private let favoritesUseCase = FavoritesUseCase(repository: FavoritesRepository())
    
    lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .navigateToSigninViewController:
            return navigateToSigninViewController()
        case .navigateToTabBarController:
            return navigateToTabBarController()
            
        case .presentToLanguageSettingAlertController(let reactor):
            return presentToLanguageSettingAlertController(reactor: reactor)
            
            // 프레젠트 공통 알람
        case .presentToNetworkErrorAlertController:
            return presentToNetworkErrorAlertController()
        case .presentToUnknownErrorAlertController:
            return presentToUnknownErrorAlertController()
        case .presentToAWSServerErrorAlertController:
            return presentToAWSServerErrorAlertController()
            
        case .popViewController:
            return popViewController()
        case .popToRootViewController:
            return .none
            
        case .goToSignupFlow:
            return goToSignupFlow()
        case .goToSigninFlow:
            return goToSigninFlow()
            
        case .completeSignupFlow:
            return .none
        case .completeSigninFlow:
            return navigateToTabBarController()
        case .completeMainFlow:
            return navigateToSigninViewController()
        case .completeMainFlowAfterWithdrawal:
            return navigateToSigninViewControllerAfterWithdrawal()
        }
    }
    
    private func navigateToSigninViewController() -> FlowContributors {
        let reactor = SigninReactor()
        let viewController = SigninViewController(with: reactor)
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.setViewControllers([viewController], animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToSigninViewControllerAfterWithdrawal() -> FlowContributors {
        let reactor = SigninReactor()
        let viewController = SigninViewController(with: reactor)
        reactor.action.onNext(.setShowToastMessage(true))
        self.rootViewController.isNavigationBarHidden = false
        self.rootViewController.setViewControllers([viewController], animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func presentToLanguageSettingAlertController(reactor: SigninReactor) -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "언어변경"),
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let koAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "한국어"), style: .default) { _ in
            reactor.action.onNext(.setLanguage("ko"))
        }
        let enAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "English"), style: .default) { _ in
            reactor.action.onNext(.setLanguage("en"))
        }
        let cancelAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "취소"), style: .cancel, handler: nil)

        alertController.addAction(koAction)
        alertController.addAction(enAction)
        alertController.addAction(cancelAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func navigateToTabBarController() -> FlowContributors {
        let tabBarController = TabBarController()
        self.rootViewController.isNavigationBarHidden = true
        let homeNavigationController = UINavigationController()
        let alarmNavigationController = UINavigationController()
        let settingNavigationController = UINavigationController()
        
        let homeStepper = HomeStepper()
        let alarmStepper = AlarmStepper()
        let settingStepper = SettingStepper()
        
        let homeFlow = HomeFlow(with: homeNavigationController, coinUseCase: self.coinUseCase, alarmUseCase: self.alarmUseCase, favoritesUseCase: self.favoritesUseCase, stepper: homeStepper)
        let alarmFlow = AlarmFlow(with: alarmNavigationController, coinUseCase: self.coinUseCase, indicatorUseCase: self.indicatorUseCase, alarmUseCase: self.alarmUseCase, stepper: alarmStepper)
        let settingFlow = SettingFlow(with: settingNavigationController, userUseCase: self.userUseCase, stepper: settingStepper)
        
        Flows.use(homeFlow,alarmFlow,settingFlow, when: .created) { [weak self] (homeNavigationController,alarmNavigationController,settingNavigationController) in
            
            homeNavigationController.tabBarItem = UITabBarItem(title: LocalizationManager.shared.localizedString(forKey: "홈"), image: ImageManager.home_Select?.withRenderingMode(.alwaysOriginal), tag: 0)
            alarmNavigationController.tabBarItem = UITabBarItem(title: LocalizationManager.shared.localizedString(forKey: "알람"), image: ImageManager.alarm?.withRenderingMode(.alwaysOriginal), tag: 1)
            settingNavigationController.tabBarItem = UITabBarItem(title: LocalizationManager.shared.localizedString(forKey: "설정"), image: ImageManager.setting?.withRenderingMode(.alwaysOriginal), tag: 2)

            tabBarController.viewControllers = [homeNavigationController,alarmNavigationController,settingNavigationController]
            self?.rootViewController.setViewControllers([tabBarController], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: homeStepper),
            .contribute(withNextPresentable: alarmFlow, withNextStepper: alarmStepper),
            .contribute(withNextPresentable: settingFlow, withNextStepper: settingStepper),
        ])
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
    
    private func presentToAWSServerErrorAlertController() -> FlowContributors {
        let alertController = CustomDimAlertController(title: LocalizationManager.shared.localizedString(forKey: "서버 오류"),
                                                message: LocalizationManager.shared.localizedString(forKey: "서버 오류 설명"),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizationManager.shared.localizedString(forKey: "확인"), style: .default, handler: nil)
        alertController.addAction(okAction)
        self.rootViewController.present(alertController, animated: true, completion: nil)
        
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func goToSignupFlow() -> FlowContributors {
        let signupFlow = SignupFlow(with: self.rootViewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: signupFlow, withNextStepper: OneStepper(withSingleStep: SignupStep.navigateToSignupEmailEntryViewController)))
    }
    
    private func goToSigninFlow() -> FlowContributors {
        let signinFlow = SigninFlow(with: self.rootViewController)
        
        return .one(flowContributor: .contribute(withNextPresentable: signinFlow, withNextStepper: OneStepper(withSingleStep: SigninStep.navigateToSigninEmailEntryViewController)))
    }
}

