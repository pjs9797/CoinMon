import UIKit
import ReactorKit

class LoginViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let startView = LoginView()
    
    init(with reactor: LoginReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = startView
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
    }
    
    func bindState(reactor: LoginReactor){
    }
}
