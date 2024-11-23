import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class PurchaseViewController: UIViewController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_close24?.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    let purchaseView = PurchaseView()
    
    init(with reactor: PurchaseReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = purchaseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
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

extension PurchaseViewController {
    func bind(reactor: PurchaseReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PurchaseReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        purchaseView.purchaseButton.rx.tap
            .map{ Reactor.Action.trialButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: PurchaseReactor){
        reactor.state.map{ $0.subscriptionStatus }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] subscriptionStatus in
                if subscriptionStatus.useTrialYN == "Y" {
                    self?.purchaseView.purchaseButton.setTitle(LocalizationManager.shared.localizedString(forKey: "프리미엄 구독하기"), for: .normal)
                }
                else {
                    self?.purchaseView.purchaseButton.setTitle(LocalizationManager.shared.localizedString(forKey: "14일 무료 체험하기"), for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}
