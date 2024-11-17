import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SelectIndicatorViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let selectIndicatorView = SelectIndicatorView()
    
    init(with reactor: SelectIndicatorReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
        setupNotifications()
        self.selectIndicatorView.indicatorCategoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        self.reactor?.action.onNext(.loadSubscriptionStatus)
    }
    
    private func setNavigationbar() {
        self.title = ""
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupNotifications() {
        NotificationCenter.default.rx.notification(.completeDeleteIndicatorAlarm)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] notification in
                if let userInfo = notification.userInfo,
                   let message = userInfo["message"] as? String {
                    self?.reactor?.action.onNext(.selectCategory(self?.reactor?.currentState.selectedCategory ?? 0))
                    self?.selectIndicatorView.toastMessage.toastLabel.updateAttributedText(message)
                    self?.showToastMessage(self?.selectIndicatorView.toastMessage ?? UIView())
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showToastMessage(_ toastView: UIView) {
        toastView.isHidden = false
        view.bringSubviewToFront(toastView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            toastView.isHidden = true
        }
    }
}

extension SelectIndicatorViewController {
    func bind(reactor: SelectIndicatorReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectIndicatorReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectIndicatorView.indicatorCategoryCollectionView.rx.itemSelected
            .map { Reactor.Action.selectCategory($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectIndicatorReactor){
        reactor.state.map { $0.categories }
            .distinctUntilChanged()
            .bind(to: selectIndicatorView.indicatorCategoryCollectionView.rx.items(cellIdentifier: "DetailCoinInfoCategoryCollectionViewCell", cellType: DetailCoinInfoCategoryCollectionViewCell.self)) { index, category, cell in
                
                cell.categoryLabel.text = category
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.subscriptionStatus }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.selectCategory(0))
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.indicators }
            .distinctUntilChanged()
            .bind(to: selectIndicatorView.explanIndicatorTableView.rx.items(cellIdentifier: "ExplanIndicatorTableVieCell", cellType: ExplanIndicatorTableViewCell.self)) { (index, indicatorInfo, cell) in
                
                let indicatorId = String(indicatorInfo.indicatorId)
//                cell.configure(with: indicatorInfo)
//                cell.configureTrial(indicatorId: indicatorId, subscriptionStatus: reactor.currentState.subscriptionStatus)
                cell.configure(with: indicatorInfo, subscriptionStatus: reactor.currentState.subscriptionStatus)

                let isPremium = indicatorInfo.isPremiumYN == "Y" ? true : false
                
                cell.explainButton.rx.tap
                    .map { Reactor.Action.explainButtonTapped(indicatorId: String(indicatorInfo.indicatorId)) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                
                cell.rightButton.rx.tap
                    .map { Reactor.Action.rightButtonTapped(isPushed: indicatorInfo.isPushed, indicatorId: String(indicatorInfo.indicatorId), indicatorName: indicatorInfo.indicatorName, isPremium: isPremium) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                
                cell.alarmButton.rx.tap
                    .map { Reactor.Action.alarmButtonTapped(indicatorId: String(indicatorInfo.indicatorId), indicatorName: indicatorInfo.indicatorName) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                
                cell.trialButton.rx.tap
                    .map { Reactor.Action.trialButtonTapped }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
