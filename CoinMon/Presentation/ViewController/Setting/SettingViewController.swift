import UIKit
import ReactorKit

class SettingViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let settingView = SettingView()
    
    init(with reactor: SettingReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.settingView.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.reactor?.action.onNext(.fetchUserData)
    }
}

extension SettingViewController {
    func bind(reactor: SettingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SettingReactor){
        settingView.rightButton.rx.tap
            .map{ Reactor.Action.rightButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.normalUserView.trialButton.rx.tap
            .map{ Reactor.Action.normalUserViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.trialUserViewTapGesture.rx.event
            .map{ _ in Reactor.Action.trialUserViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.subscriptionUserViewTapGesture.rx.event
            .map{ _ in Reactor.Action.subscriptionUserViewTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.languageSegmentedControl.rx.selectedSegmentIndex
            .map { $0 == 0 ? "ko" : "en" }
            .map { Reactor.Action.changeLanguage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.alarmSettingButton.rx.tap
            .map{ Reactor.Action.alarmSettingButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.inquiryButton.rx.tap
            .map{ Reactor.Action.inquiryButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.termsOfServiceButton.rx.tap
            .map{ Reactor.Action.termsOfServiceButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.privacyPolicyButton.rx.tap
            .map{ Reactor.Action.privacyPolicyButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SettingReactor){
        reactor.state.map{ $0.imageIndex }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] index in
                self?.settingView.profileImageView.image = UIImage(named: "profileImage\(index)")
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.nickname }
            .distinctUntilChanged()
            .bind(to: settingView.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
                reactor.state.map { $0.subscriptionStatus }.distinctUntilChanged(),
                LocalizationManager.shared.rxLanguage
            )
            .bind(onNext: { [weak self] status, _ in
                self?.settingView.setLocalizedText()
                self?.settingView.setUserView(status: status)
            })
            .disposed(by: disposeBag)
    }
}
