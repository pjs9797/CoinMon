import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class SubscriptionManagementViewController: UIViewController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let subscriptionManagementView = SubscriptionManagementView()
    
    init(with reactor: SubscriptionManagementReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = subscriptionManagementView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
        reactor?.action.onNext(.loadSubscriptionStatus)
    }
    
    private func setNavigationbar() {
        self.title = ""
        navigationItem.leftBarButtonItem = backButton
    }
}

extension SubscriptionManagementViewController {
    func bind(reactor: SubscriptionManagementReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SubscriptionManagementReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        subscriptionManagementView.contactButton.rx.tap
            .map{ Reactor.Action.contactButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SubscriptionManagementReactor){
        reactor.state.map { $0.subscriptionStatus }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] subscriptionStatus in
                let date = self?.reactor?.getNextPaymentDate(expiryDateString: subscriptionStatus.expiresDate ?? "YYYY-MM-DD")
                if LocalizationManager.shared.language == "ko" {
                    self?.subscriptionManagementView.subscribePeriodLabel.text = LocalizationManager.shared.localizedString(forKey: "결제 예정일 날짜", arguments: date?.0 ?? "YYYY", date?.1 ?? "MM", date?.2 ?? "DD")
                }
                else {
                    self?.subscriptionManagementView.subscribePeriodLabel.text = LocalizationManager.shared.localizedString(forKey: "결제 예정일 날짜", arguments: date?.2 ?? "DD", date?.1 ?? "MM", date?.0 ?? "YYYY")
                }
            })
            .disposed(by: disposeBag)
    }
}
