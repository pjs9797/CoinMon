import UIKit
import ReactorKit

class SignupEmailEntryViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let signupEmailEntryView = SignupEmailEntryView()
    
    init(with reactor: SignupEmailEntryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = signupEmailEntryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        bindKeyboardNotifications(to: signupEmailEntryView.nextButton, disposeBag: disposeBag)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "회원가입")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension SignupEmailEntryViewController {
    func bind(reactor: SignupEmailEntryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SignupEmailEntryReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signupEmailEntryView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signupEmailEntryView.duplicateButton.rx.tap
            .map{ Reactor.Action.duplicateButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signupEmailEntryView.emailTextField.rx.text.orEmpty
            .map{ Reactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SignupEmailEntryReactor){
        reactor.state.map { $0.email }
            .distinctUntilChanged()
            .bind(to: self.signupEmailEntryView.emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.isEmailValid }.distinctUntilChanged(),
            reactor.state.map { $0.email }.distinctUntilChanged()
        )
        .bind(onNext: { [weak self] isValid, email in
            self?.signupEmailEntryView.emailErrorLabel.isHidden = isValid || email.isEmpty
            self?.signupEmailEntryView.emailDuplicateLabel.isHidden = isValid ? false : true
            if reactor.currentState.isDuplicatedEmail == nil {
                self?.signupEmailEntryView.emailDuplicateLabel.isHidden = true
            }
            self?.signupEmailEntryView.duplicateButton.isEnabled = isValid ? true : false
            self?.signupEmailEntryView.duplicateButton.backgroundColor = isValid ? ColorManager.gray_5 : ColorManager.gray_90
        })
        .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isDuplicatedEmail }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isDuplicated in
                if let isDuplicated {
                    self?.signupEmailEntryView.emailDuplicateLabel.isHidden = false
                    self?.signupEmailEntryView.emailDuplicateLabel.text = isDuplicated ? LocalizationManager.shared.localizedString(forKey: "중복되는 이메일이에요") : LocalizationManager.shared.localizedString(forKey: "중복되지 않는 이메일이에요")
                    self?.signupEmailEntryView.emailDuplicateLabel.textColor = isDuplicated ? ColorManager.red_50 : ColorManager.green_50
                }
                else {
                    self?.signupEmailEntryView.emailDuplicateLabel.isHidden = true
                }
                
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isNextButtonEnable }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                self?.signupEmailEntryView.nextButton.isEnabled = isValid ? true : false
                self?.signupEmailEntryView.nextButton.backgroundColor = isValid ? ColorManager.orange_60 : ColorManager.gray_90
            })
            .disposed(by: disposeBag)
    }
}
