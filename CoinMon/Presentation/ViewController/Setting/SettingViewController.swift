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
        
        view.backgroundColor = .systemBackground
        
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setLocalizedText(){
        settingView.settingLabel.text = LocalizationManager.shared.localizedString(forKey: "설정")
        settingView.languageLabel.text = LocalizationManager.shared.localizedString(forKey: "언어")
        settingView.alarmSettingButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알림 설정"), for: .normal)
        settingView.myAccountButton.setTitle(LocalizationManager.shared.localizedString(forKey: "내 계정"), for: .normal)
        settingView.inquiryButton.setTitle(LocalizationManager.shared.localizedString(forKey: "문의"), for: .normal)
        settingView.termsOfServiceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "이용약관"), for: .normal)
        settingView.privacyPolicyButton.setTitle(LocalizationManager.shared.localizedString(forKey: "개인정보 처리방침"), for: .normal)
        settingView.versionLabel.text = LocalizationManager.shared.localizedString(forKey: "현재 버전")
    }
}

extension SettingViewController {
    func bind(reactor: SettingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SettingReactor){
        settingView.languageSegmentedControl.rx.selectedSegmentIndex
            .map { $0 == 0 ? "ko" : "en" }
            .map { Reactor.Action.changeLanguage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.alarmSettingButton.rx.tap
            .map{ Reactor.Action.alarmSettingButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingView.myAccountButton.rx.tap
            .map{ Reactor.Action.myAccountButtonTapped }
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
    }
}
