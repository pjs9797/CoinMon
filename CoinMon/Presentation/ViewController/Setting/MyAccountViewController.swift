import UIKit
import ReactorKit

class MyAccountViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let myAccountView = MyAccountView()
    
    init(with reactor: MyAccountReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = myAccountView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.myAccountView.setLocalizedText()
                self?.title = LocalizationManager.shared.localizedString(forKey: "내 계정")
            })
            .disposed(by: disposeBag)
        self.reactor?.action.onNext(.loadUserData)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "내 계정")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension MyAccountViewController {
    func bind(reactor: MyAccountReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MyAccountReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myAccountView.nicknameTextField.rx.text.orEmpty
            .bind(onNext: { [weak self] nickname in
                let filterNickname = String(nickname.prefix(12))
                self?.myAccountView.nicknameTextField.text = filterNickname
                reactor.action.onNext(.updateNickname(filterNickname))
            })
            .disposed(by: disposeBag)
        
        myAccountView.changeNicknameButton.rx.tap
            .map{ Reactor.Action.changeNicknameButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myAccountView.logoutButton.rx.tap
            .map{ Reactor.Action.logoutButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myAccountView.withdrawalButton.rx.tap
            .map{ Reactor.Action.withdrawalButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MyAccountReactor){
        reactor.state.map{ $0.imageIndex }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] index in
                self?.myAccountView.profileImageView.image = UIImage(named: "profileImage\(index)")
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.nickname }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] nickname in
                self?.myAccountView.nicknameTextField.text = nickname
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.nicknameErrorLabelHidden }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isHidden in
                if isHidden {
                    self?.myAccountView.nicknameErrorLabel.isHidden = true
                    self?.myAccountView.nicknameErrorLabel.isEnabled = false
                    self?.myAccountView.changeNicknameButton.setTitle(LocalizationManager.shared.localizedString(forKey: "닉네임 변경"), for: .normal)
                    self?.myAccountView.nicknameTextField.layer.borderColor = ColorManager.common_100?.cgColor
                    self?.myAccountView.nicknameTextField.leftView = nil
                    self?.myAccountView.nicknameTextField.leftViewMode = .never
                }
                else {
                    self?.myAccountView.nicknameErrorLabel.isHidden = false
                    self?.myAccountView.nicknameErrorLabel.isEnabled = true
                    self?.myAccountView.changeNicknameButton.setTitle(LocalizationManager.shared.localizedString(forKey: "저장"), for: .normal)
                    self?.myAccountView.nicknameTextField.layer.borderColor = ColorManager.orange_60?.cgColor
                    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10*ConstantsManager.standardWidth, height: 40*ConstantsManager.standardHeight))
                    self?.myAccountView.nicknameTextField.leftView = paddingView
                    self?.myAccountView.nicknameTextField.leftViewMode = .always
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.loginType }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] type in
                switch type{
                case "COINMON":
                    self?.myAccountView.loginTypeImageView.image = ImageManager.login_coinmon
                default:
                    self?.myAccountView.loginTypeImageView.image = ImageManager.login_coinmon
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.email }
            .distinctUntilChanged()
            .bind(to: self.myAccountView.emailLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
