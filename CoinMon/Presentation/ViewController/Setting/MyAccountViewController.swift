import UIKit
import ReactorKit

class MyAccountViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let myAccountView = MyAccountView()
    
    init(with reactor: MyAccountReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = myAccountView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationbar()
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.myAccountView.setLocalizedText()
                self?.title = LocalizationManager.shared.localizedString(forKey: "내 계정")
            })
            .disposed(by: disposeBag)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "내 계정")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension MyAccountViewController {
    func bind(reactor: MyAccountReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MyAccountReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myAccountView.changeNicknameButton.rx.tap
            .map{ Reactor.Action.changeNicknameButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myAccountView.logoutButton.rx.tap
            .map{ Reactor.Action.logoutButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myAccountView.withdrawalButton.rx.tap
            .map{ Reactor.Action.withdrawalButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: MyAccountReactor){
    }
}
