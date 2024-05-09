import UIKit
import ReactorKit

class SigninEmailEntryViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.Arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let emailInputView = EmailInputView()
    
    init(with reactor: EmailEntryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = emailInputView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = NSLocalizedString("로그인", comment: "")
        self.backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
}

extension SigninEmailEntryViewController {
    func bind(reactor: EmailEntryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EmailEntryReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailInputView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailInputView.clearButton.rx.tap
            .map{ Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailInputView.emailTextField.rx.text.orEmpty
            .map{ Reactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EmailEntryReactor){
        reactor.state.map { $0.email }
            .distinctUntilChanged()
            .bind(to: emailInputView.emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isClearButtonHidden }
            .distinctUntilChanged()
            .bind(to: emailInputView.clearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEmailValid }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                self?.emailInputView.emailErrorLabel.isHidden = isValid ? true : false
                self?.emailInputView.nextButton.isEnabled = isValid ? true : false
                self?.emailInputView.nextButton.backgroundColor = isValid ? ColorManager.primary : ColorManager.color_neutral_90
            })
            .disposed(by: disposeBag)
    }
}
