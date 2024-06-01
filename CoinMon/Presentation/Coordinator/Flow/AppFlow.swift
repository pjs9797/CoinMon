import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        //TODO: 로그인창과 연결시 삭제
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .navigateToSigninViewController:
            return navigateToSigninViewController()
        case .navigateToTabBarController:
            return navigateToTabBarController()
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
            return .none
        }
    }
    
    private func navigateToSigninViewController() -> FlowContributors {
        let reactor = SigninReactor()
        let viewController = SigninViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func navigateToTabBarController() -> FlowContributors {
        let tabBarController = TabBarController()
        let homeNavigationController = UINavigationController()
        let settingNavigationController = UINavigationController()
        let homeFlow = HomeFlow(with: homeNavigationController)
        let settingFlow = SettingFlow(with: settingNavigationController)
        
        Flows.use(homeFlow,settingFlow, when: .created) { [weak self] (homeNavigationController,settingNavigationController) in
            
            homeNavigationController.tabBarItem = UITabBarItem(title: LocalizationManager.shared.localizedString(forKey: "홈"), image: ImageManager.home_Select?.withRenderingMode(.alwaysOriginal), tag: 0)
            settingNavigationController.tabBarItem = UITabBarItem(title: LocalizationManager.shared.localizedString(forKey: "설정"), image: ImageManager.setting?.withRenderingMode(.alwaysOriginal), tag: 1)

            tabBarController.viewControllers = [homeNavigationController,settingNavigationController]
            self?.rootViewController.setViewControllers([tabBarController], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: homeFlow, withNextStepper: OneStepper(withSingleStep: HomeStep.navigateToHomeViewController)),
            .contribute(withNextPresentable: settingFlow, withNextStepper: OneStepper(withSingleStep: SettingStep.navigateToSettingViewController)),
        ])
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

