import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.layer.shadowColor = ColorManager.common_0?.cgColor
        tabBar.layer.shadowOpacity = 0.06
        tabBar.layer.shadowRadius = 12
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowPath = UIBezierPath(rect: tabBar.bounds).cgPath
    }
}

extension TabBarController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewControllers = viewControllers {
            for (index, viewController) in viewControllers.enumerated() {
                if let tabItem = viewController.tabBarItem {
                    if index == 0 {
                        tabItem.image = viewController == viewController ? ImageManager.home_Select : ImageManager.home
                    }
                    else if index == 1 {
                        tabItem.image = viewController == viewController ? ImageManager.alert_Select : ImageManager.alert
                    }
                    else if index == 2 {
                        tabItem.image = viewController == viewController ? ImageManager.setting_Select : ImageManager.setting
                    }
                }
            }
        }
    }
}
