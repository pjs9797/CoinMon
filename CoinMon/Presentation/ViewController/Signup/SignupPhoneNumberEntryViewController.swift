import UIKit
import ReactorKit

class SignupPhoneNumberEntryViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.Arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let phoneNumberEntryView = PhoneNumberEntryView()
    
    init(with reactor: SignupPhoneNumberEntryReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = phoneNumberEntryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = NSLocalizedString("회원가입", comment: "")
        self.backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
    }
}

extension SignupPhoneNumberEntryViewController {
    func bind(reactor: SignupPhoneNumberEntryReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SignupPhoneNumberEntryReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        phoneNumberEntryView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        phoneNumberEntryView.clearButton.rx.tap
            .map{ Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        phoneNumberEntryView.phoneNumberTextField.rx.text.orEmpty
            .map{ Reactor.Action.updatePhoneNumber($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SignupPhoneNumberEntryReactor){
        reactor.state.map { $0.phoneNumber }
            .distinctUntilChanged()
            .bind(to: phoneNumberEntryView.phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isClearButtonHidden }
            .distinctUntilChanged()
            .bind(to: phoneNumberEntryView.clearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPhoneNumberValid }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                self?.phoneNumberEntryView.nextButton.isEnabled = isValid ? true : false
                self?.phoneNumberEntryView.nextButton.backgroundColor = isValid ? ColorManager.primary : ColorManager.color_neutral_90
            })
            .disposed(by: disposeBag)
    }
}
