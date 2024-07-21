import UIKit
import RxSwift

class TabBarController: UITabBarController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupTabBar()
        setLocalizedText()
        
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.shadowColor = ColorManager.common_0?.cgColor
        tabBar.layer.shadowOpacity = 0.06
        tabBar.layer.shadowRadius = 12
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowPath = UIBezierPath(rect: tabBar.bounds).cgPath
        tabBar.tintColor = ColorManager.gray_30
        tabBar.unselectedItemTintColor = ColorManager.gray_90
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: AttributedFontManager.T8_10
        ]
        self.tabBarController?.tabBarItem.setTitleTextAttributes(textAttributes, for: .normal)
        self.tabBarController?.tabBarItem.setTitleTextAttributes(textAttributes, for: .selected)
    }
    
    private func setLocalizedText() {
        guard let viewControllers = viewControllers else { return }
        
        for (index, viewController) in viewControllers.enumerated() {
            if let tabItem = viewController.tabBarItem {
                switch index {
                case 0:
                    tabItem.title = LocalizationManager.shared.localizedString(forKey: "홈")
                case 1:
                    tabItem.title = LocalizationManager.shared.localizedString(forKey: "알람")
                case 2:
                    tabItem.title = LocalizationManager.shared.localizedString(forKey: "설정")
                default:
                    break
                }
            }
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewControllers = viewControllers {
            for (index, vc) in viewControllers.enumerated() {
                if let tabItem = vc.tabBarItem {
                    if index == 0 {
                        tabItem.image = vc == viewController ? ImageManager.home_Select?.withRenderingMode(.alwaysOriginal) : ImageManager.home?.withRenderingMode(.alwaysOriginal)
                    } 
                    else if index == 1 {
                        tabItem.image = vc == viewController ? ImageManager.alarm_Select?.withRenderingMode(.alwaysOriginal) : ImageManager.alarm?.withRenderingMode(.alwaysOriginal)
                    }
                    else if index == 2 {
                        tabItem.image = vc == viewController ? ImageManager.setting_Select?.withRenderingMode(.alwaysOriginal) : ImageManager.setting?.withRenderingMode(.alwaysOriginal)
                    }
                }
            }
        }
    }
}
