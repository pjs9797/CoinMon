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
        
        // 앱이 시작될 때 제품 로드
        Task {
            do {
                try await PurchaseManager.shared.loadProducts()
            } catch {
                print("Failed to load products: \(error.localizedDescription)")
            }
        }
        
        // 앱이 시작될 때 트랜잭션 업데이트 감시 시작
        PurchaseManager.shared.startObservingTransactionUpdates()
        
        
        window = UIWindow(windowScene: windowScene)
        appFlow = AppFlow()
        Flows.use(appFlow, when: .created) { [unowned self] root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        }
        if CommandLine.arguments.contains("UItesting--isLoggedIn") {
            coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.navigateToSigninViewController))
        }
        else {
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            if isLoggedIn {
                coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.navigateToTabBarController))
            }
            else {
                coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.navigateToSigninViewController))
            }
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
