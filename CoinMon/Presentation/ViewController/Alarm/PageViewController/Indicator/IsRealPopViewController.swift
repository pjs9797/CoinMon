import UIKit
import ReactorKit
import RxCocoa

class IsRealPopViewController: CustomDimSheetPresentationController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let isRealPopView = IsRealPopView()
    
    init(with reactor: IsRealPopReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = isRealPopView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension IsRealPopViewController {
    func bind(reactor: IsRealPopReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: IsRealPopReactor){
        isRealPopView.continueButton.rx.tap
            .map{ Reactor.Action.continueButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        isRealPopView.outButton.rx.tap
            .map{ Reactor.Action.outButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: IsRealPopReactor){
    }
}
