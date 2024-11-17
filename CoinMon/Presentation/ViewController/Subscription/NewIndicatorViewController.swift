import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class NewIndicatorViewController: CustomDimSheetPresentationController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let newIndicatorView = NewIndicatorView()
    
    init(with reactor: NewIndicatorReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = newIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
    }
}

extension NewIndicatorViewController {
    func bind(reactor: NewIndicatorReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: NewIndicatorReactor){        
        newIndicatorView.trialButton.rx.tap
            .map{ Reactor.Action.trialButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: NewIndicatorReactor){
    }
}
