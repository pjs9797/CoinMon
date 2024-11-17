import UIKit
import ReactorKit

class SignupCompletedViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let signupCompletedView = SignupCompletedView()
    
    init(with reactor: SignupCompletedReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = signupCompletedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension SignupCompletedViewController {
    func bind(reactor: SignupCompletedReactor) {
        bindAction(reactor: reactor)
    }
    
    func bindAction(reactor: SignupCompletedReactor){
        signupCompletedView.signupCompletedButton.rx.tap
            .map{ Reactor.Action.signupCompletedButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
