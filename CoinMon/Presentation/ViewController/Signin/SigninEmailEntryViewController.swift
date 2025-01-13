import UIKit
import ReactorKit

class SigninEmailEntryViewController: BaseViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let signinEmailEntryView = SigninEmailEntryView()
    
    init(with reactor: SigninEmailEntryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = signinEmailEntryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBar(title: LocalizationManager.shared.localizedString(forKey: "로그인"), leftItem: backButton, rightItem: nil)
        self.hideKeyboard(disposeBag: disposeBag)
        self.bindKeyboardToButton(to: signinEmailEntryView.nextButton, disposeBag: disposeBag)
        backButton.accessibilityIdentifier = "signin_backButton"
    }
}

extension SigninEmailEntryViewController {
    func bind(reactor: SigninEmailEntryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SigninEmailEntryReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signinEmailEntryView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signinEmailEntryView.clearButton.rx.tap
            .map{ Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signinEmailEntryView.emailTextField.rx.text.orEmpty
            .map{ Reactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SigninEmailEntryReactor){
        reactor.state.map { $0.email }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] email in
                self?.signinEmailEntryView.emailTextField.updateText(email)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isClearButtonHidden }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: signinEmailEntryView.clearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.isEmailValid }.distinctUntilChanged(),
            reactor.state.map { $0.email }.distinctUntilChanged()
        )
        .observe(on: MainScheduler.asyncInstance)
        .bind(onNext: { [weak self] isValid, email in
            self?.signinEmailEntryView.emailErrorLabel.isHidden = isValid || email.isEmpty
            self?.signinEmailEntryView.nextButton.isEnabled = isValid
            self?.signinEmailEntryView.nextButton.backgroundColor = isValid ? ColorManager.orange_60 : ColorManager.gray_90
        })
        .disposed(by: disposeBag)
    }
}
