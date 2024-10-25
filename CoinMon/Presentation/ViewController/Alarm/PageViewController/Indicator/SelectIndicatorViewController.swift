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
        self.selectIndicatorView.indicatorCategoryCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    private func setNavigationbar() {
        self.title = ""
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reactor?.action.onNext(.selectCategory(reactor?.currentState.selectedCategory ?? 0))
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
        
        reactor.state.map { $0.indicators }
            .distinctUntilChanged()
            .bind(to: selectIndicatorView.explanIndicatorTableView.rx.items(cellIdentifier: "ExplanIndicatorTableVieCell", cellType: ExplanIndicatorTableViewCell.self)) { (index, indicatorInfo, cell) in
                cell.configure(with: indicatorInfo)
                let isPremium = indicatorInfo.isPremiumYN == "Y" ? true : false
                
                cell.explainButton.rx.tap
                    .map { Reactor.Action.explainButtonTapped(indicatorId: String(indicatorInfo.indicatorId)) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
                
                cell.rightButton.rx.tap
                    .map { Reactor.Action.rightButtonTapped(isPushed: indicatorInfo.isPushed, indicatorId: String(indicatorInfo.indicatorId), indicatorName: indicatorInfo.indicatorName, isPremium: isPremium) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
