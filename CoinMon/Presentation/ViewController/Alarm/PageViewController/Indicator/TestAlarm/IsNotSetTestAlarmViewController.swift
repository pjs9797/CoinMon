import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class IsNotSetTestAlarmViewController: CustomDimSheetPresentationController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let isNotSetTestAlarmView = IsNotSetTestAlarmView()
    
    init(with reactor: IsNotSetTestAlarmReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = isNotSetTestAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension IsNotSetTestAlarmViewController {
    func bind(reactor: IsNotSetTestAlarmReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: IsNotSetTestAlarmReactor){
        isNotSetTestAlarmView.laterButton.rx.tap
            .map{ Reactor.Action.laterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        isNotSetTestAlarmView.setAlarmButton.rx.tap
            .map{ Reactor.Action.setAlarmButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: IsNotSetTestAlarmReactor){
    }
}
