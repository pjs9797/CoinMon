import UIKit
import ReactorKit

class PhoneVerificationNumberViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let verificationNumberView = VerificationNumberView(verificationType: VerificationType.phone)
    
    init(with reactor: PhoneVerificationNumberReactor) {
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
        
        view.backgroundColor = .systemBackground
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        bindKeyboardToButton(to: verificationNumberView.nextButton, disposeBag: disposeBag)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "회원가입")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension PhoneVerificationNumberViewController {
    func bind(reactor: PhoneVerificationNumberReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PhoneVerificationNumberReactor){
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
    
    func bindState(reactor: PhoneVerificationNumberReactor){
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
    }
}
