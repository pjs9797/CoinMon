import UIKit
import ReactorKit

class SigninViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let signinView = SigninView()
    
    init(with reactor: SigninReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = signinView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
}

extension SigninViewController {
    func bind(reactor: SigninReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SigninReactor){
        signinView.coinMonLoginButton.rx.tap
            .map{ Reactor.Action.coinMonLoginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signinView.signupButton.rx.tap
            .map{ Reactor.Action.signupButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SigninReactor){
    }
}
