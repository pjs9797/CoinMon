import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class ResendTestAlarmViewController: CustomDimSheetPresentationController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let resendTestAlarmView = ResendTestAlarmView()
    
    init(with reactor: ResendTestAlarmReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = resendTestAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension ResendTestAlarmViewController {
    func bind(reactor: ResendTestAlarmReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: ResendTestAlarmReactor){
        resendTestAlarmView.laterButton.rx.tap
            .map{ Reactor.Action.laterButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        resendTestAlarmView.receiveButton.rx.tap
            .map{ Reactor.Action.receiveButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: ResendTestAlarmReactor){
    }
}
