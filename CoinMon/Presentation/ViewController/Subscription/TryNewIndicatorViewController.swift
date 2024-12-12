import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class TryNewIndicatorViewController: UIViewController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_close24?.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    let tryNewIndicatorView = TryNewIndicatorView()
    
    init(with reactor: TryNewIndicatorReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = tryNewIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setNavigationbar() {
        self.title = ""
        backButton.tintColor = ColorManager.common_100 ?? .white
        navigationItem.rightBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = .black
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
}

extension TryNewIndicatorViewController {
    func bind(reactor: TryNewIndicatorReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: TryNewIndicatorReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tryNewIndicatorView.explainIndicatorButton.rx.tap
            .map{ Reactor.Action.explainIndicatorButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tryNewIndicatorView.trialButton.rx.tap
            .map{ Reactor.Action.trialButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: TryNewIndicatorReactor){
    }
}
