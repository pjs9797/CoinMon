import UIKit
import SnapKit
import ReactorKit
import RxCocoa

class SuccessSubscriptionViewController: UIViewController, ReactorKit.View{
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.icon_close24, style: .plain, target: nil, action: nil)
    let managementButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(forKey: "구독관리"), style: .plain, target: nil, action: nil)
    let successSubscriptionView = SuccessSubscriptionView()
    private var originalPopGestureDelegate: UIGestureRecognizerDelegate?
    
    init(with reactor: SuccessSubscriptionReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = successSubscriptionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
        reactor?.action.onNext(.presentAlertController)
        reactor?.action.onNext(.loadSubscriptionStatus)
    }
    
    private func setNavigationbar() {
        self.title = ""
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.gray_50 ?? .gray,
            .font: FontManager.T3_16
        ]
        managementButton.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = managementButton
    }
}

extension SuccessSubscriptionViewController {
    func bind(reactor: SuccessSubscriptionReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SuccessSubscriptionReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        managementButton.rx.tap
            .map{ Reactor.Action.managementButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SuccessSubscriptionReactor){
        reactor.state.map { $0.subscriptionStatus }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] subscriptionStatus in
                let date = self?.reactor?.convertDateToTuple(dateString: subscriptionStatus.expiresDate ?? "YYYY-MM-DD")
                if LocalizationManager.shared.language == "ko" {
                    self?.successSubscriptionView.subscribePeriodLabel.text = LocalizationManager.shared.localizedString(forKey: "이용 기간", arguments: date?.0 ?? "YYYY", date?.1 ?? "MM", date?.2 ?? "DD")
                }
                else {
                    self?.successSubscriptionView.subscribePeriodLabel.text = LocalizationManager.shared.localizedString(forKey: "이용 기간", arguments: date?.2 ?? "DD", date?.1 ?? "MM", date?.0 ?? "YYYY")
                }
            })
            .disposed(by: disposeBag)
    }
}
