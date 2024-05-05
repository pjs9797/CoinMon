import UIKit
import ReactorKit

class LoginViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let loginView = LoginView()
    
    init(with reactor: LoginReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
}

extension LoginViewController {
    func bind(reactor: LoginReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: LoginReactor){
        loginView.signupButton.rx.tap
            .map{ Reactor.Action.signupButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: LoginReactor){
    }
}
