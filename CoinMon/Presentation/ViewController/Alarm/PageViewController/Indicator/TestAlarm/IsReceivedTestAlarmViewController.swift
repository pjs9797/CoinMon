import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class IsReceivedTestAlarmViewController: CustomDimSheetPresentationController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let isReceivedTestAlarmView = IsReceivedTestAlarmView()
    
    init(with reactor: IsReceivedTestAlarmReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = isReceivedTestAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension IsReceivedTestAlarmViewController {
    func bind(reactor: IsReceivedTestAlarmReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: IsReceivedTestAlarmReactor){
        isReceivedTestAlarmView.isNotReceivedButton.rx.tap
            .map{ Reactor.Action.isNotReceivedButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        isReceivedTestAlarmView.isReceivedButton.rx.tap
            .map{ Reactor.Action.isReceivedButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: IsReceivedTestAlarmReactor){
    }
}
