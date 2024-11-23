import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class LaunchViewController: UIViewController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let launchView = LaunchView()
    
    init(with reactor: LaunchReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = launchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.reactor?.action.onNext(.checkRefreshToken)
        }
    }
}

extension LaunchViewController {
    func bind(reactor: LaunchReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: LaunchReactor){
    }
    
    func bindState(reactor: LaunchReactor){
    }
}
