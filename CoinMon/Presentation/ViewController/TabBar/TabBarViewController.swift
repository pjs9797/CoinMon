import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class TabBarController: UITabBarController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let trialTooltipView = TooltipView(message: "지표 프리미엄 무료 체험✨")
    let notSetAlarmTooltipView = TooltipView(message: "구독한 알림 이어 설정하기")
    
    init(reactor: TabBarReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setLocalizedText()
        layout()
        
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = ColorManager.common_100
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
        trialTooltipView.tooltipLabel.text = LocalizationManager.shared.localizedString(forKey: "지표 프리미엄 무료 체험✨")
        notSetAlarmTooltipView.tooltipLabel.text = LocalizationManager.shared.localizedString(forKey: "구독한 알림 이어 설정하기")
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
    
    private func layout() {
        [trialTooltipView,notSetAlarmTooltipView]
            .forEach{
                tabBar.addSubview($0)
            }
        
        trialTooltipView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(300)
            make.height.lessThanOrEqualTo(300)
            make.centerX.equalTo(tabBar)
            make.bottom.equalTo(tabBar.snp.top).offset(-4*ConstantsManager.standardHeight)
        }
        
        notSetAlarmTooltipView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(300)
            make.height.lessThanOrEqualTo(300)
            make.centerX.equalTo(tabBar)
            make.bottom.equalTo(tabBar.snp.top).offset(-4*ConstantsManager.standardHeight)
        }
    }
}

extension TabBarController {
    func bind(reactor: TabBarReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: TabBarReactor) {
        self.rx.didSelect
            .map { viewController -> Int in
                return self.viewControllers?.firstIndex(of: viewController) ?? 0
            }
            .map { Reactor.Action.tabSelected(index: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: TabBarReactor) {
        reactor.state.map { $0.selectedIndex }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] index in
                guard let self = self, let viewControllers = self.viewControllers else { return }
                for (i, vc) in viewControllers.enumerated() {
                    if let tabItem = vc.tabBarItem {
                        switch i {
                        case 0:
                            tabItem.image = vc == self.selectedViewController ? ImageManager.home_Select?.withRenderingMode(.alwaysOriginal) : ImageManager.home?.withRenderingMode(.alwaysOriginal)
                        case 1:
                            tabItem.image = vc == self.selectedViewController ? ImageManager.alarm_Select?.withRenderingMode(.alwaysOriginal) : ImageManager.alarm?.withRenderingMode(.alwaysOriginal)
                        case 2:
                            tabItem.image = vc == self.selectedViewController ? ImageManager.setting_Select?.withRenderingMode(.alwaysOriginal) : ImageManager.setting?.withRenderingMode(.alwaysOriginal)
                        default:
                            break
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isTrialTooltipHidden }
            .distinctUntilChanged()
            .bind(to: trialTooltipView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNotSetAlarmTooltipHidden }
            .distinctUntilChanged()
            .bind(to: notSetAlarmTooltipView.rx.isHidden)
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.isPurchased)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.trialTooltipView.isHidden = true
                self?.reactor?.action.onNext(.setTrialTooltipHidden(true))
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.isOutSelectCoinAtPremium)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.notSetAlarmTooltipView.isHidden = false
                UserDefaultsManager.shared.saveNotSetAlarmTooltipHidden(false)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.isCompletedSelectCoinAtPremium)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.notSetAlarmTooltipView.isHidden = true
                UserDefaultsManager.shared.saveNotSetAlarmTooltipHidden(true)
            })
            .disposed(by: disposeBag)
    }
}
