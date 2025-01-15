import UIKit
import ReactorKit

class SignupEmailVerificationNumberViewController: BaseViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let verificationNumberView = VerificationNumberView()
    
    init(with reactor: SignupEmailVerificationNumberReactor) {
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
        
        self.setNavigationBar(title: LocalizationManager.shared.localizedString(forKey: "회원가입"), leftItem: backButton, rightItem: nil)
        self.hideKeyboard(disposeBag: disposeBag)
        self.bindKeyboardToButton(to: verificationNumberView.nextButton, disposeBag: disposeBag)
        self.reactor?.action.onNext(.postEmailCode)
    }
}

extension SignupEmailVerificationNumberViewController {
    func bind(reactor: SignupEmailVerificationNumberReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SignupEmailVerificationNumberReactor){
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
        
        NotificationCenter.default.rx.notification(Notification.Name("presentToAgreeToTermsOfServiceViewController"))
            .map { _ in Reactor.Action.presentToAgreeToTermsOfServiceViewController }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SignupEmailVerificationNumberReactor){
        reactor.state.map{ $0.timerText }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] time in
                self?.verificationNumberView.timerLabel.updateText(time)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.verificationNumber }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] number in
                self?.verificationNumberView.verificationNumberTextField.updateText(number)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isClearButtonHidden }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: verificationNumberView.clearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isVerificationNumberValid }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                if isValid {
                    self?.verificationNumberView.nextButton.isEnable()
                }
                else {
                    self?.verificationNumberView.nextButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}
