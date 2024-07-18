import UIKit
import ReactorKit

class WithdrawalViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let withdrawalView = WithdrawalView()
    
    init(with reactor: WithdrawalReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = withdrawalView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setNavigationbar()
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.withdrawalView.setLocalizedText()
                self?.title = LocalizationManager.shared.localizedString(forKey: "회원탈퇴네비타이틀")
            })
            .disposed(by: disposeBag)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "회원탈퇴네비타이틀")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension WithdrawalViewController {
    func bind(reactor: WithdrawalReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: WithdrawalReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        withdrawalView.checkButton.rx.tap
            .map{ Reactor.Action.checkButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        withdrawalView.withdrawalButton.rx.tap
            .map{ Reactor.Action.withdrawAlertButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: WithdrawalReactor){
        reactor.state.map{ $0.isChecked }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isChecked in
                self?.withdrawalView.checkButton.setImage(isChecked ? ImageManager.square_Check_Select : ImageManager.square_Check_None, for: .normal)
                self?.withdrawalView.withdrawalButton.isEnabled = isChecked ? true : false
                self?.withdrawalView.withdrawalButton.backgroundColor = isChecked ? ColorManager.orange_60 : ColorManager.gray_90
            })
            .disposed(by: disposeBag)
    }
}
