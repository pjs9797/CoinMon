import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    var appFlow: AppFlow!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        appFlow = AppFlow()
        Flows.use(appFlow, when: .created) { [unowned self] root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        }
        
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.navigateToTabBarController))
        }
        else {
            coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.navigateToSigninViewController))
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
    
