import UIKit
import ReactorKit

class SelectCycleForIndicatorViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let selectCycleForIndicatorView = SelectCycleForIndicatorView()
    
    init(with reactor: SelectCycleForIndicatorReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectCycleForIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
    }
    
    private func setNavigationbar() {
        self.title = ""
        navigationItem.leftBarButtonItem = backButton
    }
}

extension SelectCycleForIndicatorViewController {
    func bind(reactor: SelectCycleForIndicatorReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectCycleForIndicatorReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCycleForIndicatorView.completeButton.rx.tap
            .map{ Reactor.Action.completeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectCycleForIndicatorReactor){
        reactor.state.map{ $0.indicatorName }
            .bind(to: selectCycleForIndicatorView.indicatorLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isPremium }
            .bind(onNext: { [weak self] isPremium in
                if isPremium {
                    self?.selectCycleForIndicatorView.premiumLabel.isHidden = false
                    self?.selectCycleForIndicatorView.premiumExplainLabel.isHidden = false
                    self?.selectCycleForIndicatorView.freeExplainLabel.isHidden = true
                    self?.selectCycleForIndicatorView.freeExplainSubLabel.isHidden = true
                }
                else {
                    self?.selectCycleForIndicatorView.premiumLabel.isHidden = true
                    self?.selectCycleForIndicatorView.premiumExplainLabel.isHidden = true
                    self?.selectCycleForIndicatorView.freeExplainLabel.isHidden = false
                    self?.selectCycleForIndicatorView.freeExplainSubLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.indicatorId }
            .bind(onNext: { [weak self] indicatorId in
                self?.selectCycleForIndicatorView.explainImageView.image = UIImage(named: "indicator\(indicatorId)")
            })
            .disposed(by: disposeBag)
    }
}
