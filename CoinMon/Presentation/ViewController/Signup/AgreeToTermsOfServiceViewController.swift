import UIKit
import ReactorKit

class AgreeToTermsOfServiceViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let agreeToTermsOfServiceView = AgreeToTermsOfServiceView()
    
    init(with reactor: AgreeToTermsOfServiceReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = agreeToTermsOfServiceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
}

extension AgreeToTermsOfServiceViewController {
    func bind(reactor: AgreeToTermsOfServiceReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: AgreeToTermsOfServiceReactor){
        agreeToTermsOfServiceView.selectAllButton.rx.tap
            .map { Reactor.Action.selectAllButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreeToTermsOfServiceView.termsOfServiceCheckButton.rx.tap
            .map { Reactor.Action.firstCheckButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreeToTermsOfServiceView.termsOfServiceDetailButton.rx.tap
            .map{ Reactor.Action.termsOfServiceDetailButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreeToTermsOfServiceView.privacyPolicyViewCheckButton.rx.tap
            .map { Reactor.Action.secondCheckButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreeToTermsOfServiceView.privacyPolicyViewDetailButton.rx.tap
            .map{ Reactor.Action.privacyPolicyDetailButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreeToTermsOfServiceView.marketingConsentViewCheckButton.rx.tap
            .map { Reactor.Action.thirdCheckButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreeToTermsOfServiceView.marketingConsentViewDetailButton.rx.tap
            .map{ Reactor.Action.marketingConsentDetailButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        agreeToTermsOfServiceView.nextButton.rx.tap
            .map{ Reactor.Action.nextButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func bindState(reactor: AgreeToTermsOfServiceReactor){
        reactor.state.map { $0.isSelectAllButtonChecked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isChecked in
                self?.agreeToTermsOfServiceView.selectAllButton.setImage(isChecked ? ImageManager.circle_Check_Orange : ImageManager.circle_Check, for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isFirstCheckButtonChecked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isChecked in
                self?.agreeToTermsOfServiceView.termsOfServiceCheckButton.setImage(isChecked ? ImageManager.check?.withTintColor(ColorManager.orange_60!) : ImageManager.check, for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSecondCheckButtonChecked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isChecked in
                self?.agreeToTermsOfServiceView.privacyPolicyViewCheckButton.setImage(isChecked ? ImageManager.check?.withTintColor(ColorManager.orange_60!) : ImageManager.check, for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isThirdCheckButtonChecked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isChecked in
                self?.agreeToTermsOfServiceView.marketingConsentViewCheckButton.setImage(isChecked ? ImageManager.check?.withTintColor(ColorManager.orange_60!) : ImageManager.check, for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNextButtonValid }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                self?.agreeToTermsOfServiceView.nextButton.isEnabled = isValid ? true : false
                self?.agreeToTermsOfServiceView.nextButton.backgroundColor = isValid ? ColorManager.orange_60 : ColorManager.gray_90
            })
            .disposed(by: disposeBag)
    }
}
