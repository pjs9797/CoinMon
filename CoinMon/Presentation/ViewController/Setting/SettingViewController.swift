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
        
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
    
    private func setLocalizedText(){
        settingView.settingLabel.text = LocalizationManager.shared.localizedString(forKey: "설정")
        settingView.languageLabel.text = LocalizationManager.shared.localizedString(forKey: "언어")
        settingView.alertSettingButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알림 설정"), for: .normal)
        settingView.myAccountButton.setTitle(LocalizationManager.shared.localizedString(forKey: "내 계정"), for: .normal)
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
        
        settingView.myAccountButton.rx.tap
            .map{ Reactor.Action.myAccountButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SettingReactor){
        reactor.state.map { $0.currentLanguage }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] newLanguage in
                print("Language changed to: \(newLanguage)")
            })
            .disposed(by: disposeBag)
    }
}
