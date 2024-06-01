import UIKit
import ReactorKit

class EmailVerificationNumberViewController: UIViewController, ReactorKit.View {
    var emailFlow: EmailFlow
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let verificationNumberView = VerificationNumberView(verificationType: VerificationType.email)
    
    init(with reactor: EmailVerificationNumberReactor, emailFlow: EmailFlow) {
        self.emailFlow = emailFlow
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = verificationNumberView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        bindKeyboardNotifications(to: verificationNumberView.nextButton, disposeBag: disposeBag)
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

extension EmailVerificationNumberViewController {
    func bind(reactor: EmailVerificationNumberReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EmailVerificationNumberReactor){
        reactor.action.onNext(.startTimer)
        
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        verificationNumberView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        verificationNumberView.clearButton.rx.tap
            .map{ Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        verificationNumberView.verificationNumberTextField.rx.text.orEmpty
            .map{ Reactor.Action.updateVerificationNumber($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EmailVerificationNumberReactor){
        reactor.state.map{ $0.remainingSeconds }
            .distinctUntilChanged()
            .map { seconds -> String in
                let minutes = seconds / 60
                let seconds = seconds % 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
            .bind(to: verificationNumberView.timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.verificationNumber }
            .distinctUntilChanged()
            .bind(to: verificationNumberView.verificationNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isClearButtonHidden }
            .distinctUntilChanged()
            .bind(to: verificationNumberView.clearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isVerificationNumberValid }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                self?.verificationNumberView.nextButton.isEnabled = isValid ? true : false
                self?.verificationNumberView.nextButton.backgroundColor = isValid ? ColorManager.orange_60 : ColorManager.gray_90
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.nextButtonTitle }
            .distinctUntilChanged()
            .bind(to: verificationNumberView.nextButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
}
