import UIKit
import ReactorKit

class EmailEntryViewController: UIViewController, ReactorKit.View {
    var emailFlow: EmailFlow
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let emailEntryView = EmailEntryView()
    
    init(with reactor: EmailEntryReactor, emailFlow: EmailFlow) {
        self.emailFlow = emailFlow
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = emailEntryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        bindKeyboardNotifications(to: emailEntryView.nextButton, disposeBag: disposeBag)
    }
    
    private func setNavigationbar() {
        switch emailFlow {
        case .signup:
            self.title = NSLocalizedString("회원가입", comment: "")
        case .signin:
            self.title = NSLocalizedString("로그인", comment: "")
        }
        navigationItem.leftBarButtonItem = backButton
    }
}

extension EmailEntryViewController {
    func bind(reactor: EmailEntryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EmailEntryReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailEntryView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailEntryView.clearButton.rx.tap
            .map{ Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailEntryView.emailTextField.rx.text.orEmpty
            .map{ Reactor.Action.updateEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EmailEntryReactor){
        reactor.state.map { $0.email }
            .distinctUntilChanged()
            .bind(to: emailEntryView.emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isClearButtonHidden }
            .distinctUntilChanged()
            .bind(to: emailEntryView.clearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEmailValid }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                self?.emailEntryView.emailErrorLabel.isHidden = isValid ? true : false
                self?.emailEntryView.nextButton.isEnabled = isValid ? true : false
                self?.emailEntryView.nextButton.backgroundColor = isValid ? ColorManager.orange_60 : ColorManager.gray_90
            })
            .disposed(by: disposeBag)
    }
}
