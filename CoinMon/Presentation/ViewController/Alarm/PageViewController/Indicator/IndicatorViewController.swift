import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class IndicatorViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let indicatorView = IndicatorView()
    
    init(with reactor: IndicatorReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = indicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.gray_99
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.indicatorView.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
}

extension IndicatorViewController {
    func bind(reactor: IndicatorReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: IndicatorReactor){
        indicatorView.addIndicatorButton.rx.tap
            .map{ Reactor.Action.addIndicatorButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func bindState(reactor: IndicatorReactor){
    }
}
