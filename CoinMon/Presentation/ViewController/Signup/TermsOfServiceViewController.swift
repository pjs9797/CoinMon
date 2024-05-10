import UIKit
import ReactorKit

class TermsOfServiceViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let termsOfServiceView = TermsOfServiceView()
    
    init(with reactor: TermsOfServiceReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = termsOfServiceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
}

extension TermsOfServiceViewController {
    func bind(reactor: TermsOfServiceReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: TermsOfServiceReactor){
        termsOfServiceView.selectAllButton.rx.tap
            .map { Reactor.Action.selectAllButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        termsOfServiceView.firstCheckButton.rx.tap
            .map { Reactor.Action.firstCheckButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        termsOfServiceView.secondCheckButton.rx.tap
            .map { Reactor.Action.secondCheckButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        termsOfServiceView.thirdCheckButton.rx.tap
            .map { Reactor.Action.thirdCheckButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func bindState(reactor: TermsOfServiceReactor){
        reactor.state.map { $0.isSelectAllButtonChecked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isChecked in
                self?.termsOfServiceView.selectAllButton.tintColor = isChecked ? ColorManager.primary : ColorManager.color_neutral_90
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isFirstCheckButtonChecked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isChecked in
                self?.termsOfServiceView.firstCheckButton.imageView?.tintColor = isChecked ? ColorManager.primary : ColorManager.color_neutral_90
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSecondCheckButtonChecked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isChecked in
                self?.termsOfServiceView.secondCheckButton.imageView?.tintColor = isChecked ? ColorManager.primary : ColorManager.color_neutral_90
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isThirdCheckButtonChecked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isChecked in
                self?.termsOfServiceView.thirdCheckButton.imageView?.tintColor = isChecked ? ColorManager.primary : ColorManager.color_neutral_90
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNextButtonValid }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isValid in
                self?.termsOfServiceView.nextButton.isEnabled = isValid ? true : false
                self?.termsOfServiceView.nextButton.backgroundColor = isValid ? ColorManager.primary : ColorManager.color_neutral_90
            })
            .disposed(by: disposeBag)
    }
}
