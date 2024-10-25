import UIKit
import ReactorKit

class PriceViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let priceView = PriceView()
    
    init(with reactor: PriceReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = priceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        hideKeyboard(disposeBag: disposeBag)
        setupNotifications()
        priceView.marketCollectionView.dragDelegate = self
        priceView.marketCollectionView.dropDelegate = self
        priceView.marketCollectionView.dragInteractionEnabled = true
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.updateLocalizedMarkets)
                self?.priceView.setLocalizedText()
            })
            .disposed(by: disposeBag)
        self.reactor?.action.onNext(.loadPriceList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reactor?.action.onNext(.startTimer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.reactor?.action.onNext(.stopTimer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollBehavior()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.rx.notification(.favoritesUpdated)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.loadPriceList)
                self?.priceView.toastMessage.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self?.priceView.toastMessage.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.favoritesDeleted)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.loadPriceList)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.seeFavorites)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.favoriteButtonTapped)
            })
            .disposed(by: disposeBag)
    }
}

extension PriceViewController {
    func bind(reactor: PriceReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PriceReactor){
        priceView.marketCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        priceView.priceCategoryView.marketButton.rx.tap
            .map{ Reactor.Action.marketButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceView.priceCategoryView.favoriteButton.rx.tap
            .map{ Reactor.Action.favoriteButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceView.priceCategoryView.editButton.rx.tap
            .map{ Reactor.Action.editButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceView.marketCollectionView.rx.itemSelected
            .map { Reactor.Action.selectMarket($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        priceView.marketCollectionView.rx.itemSelected
//            .map{ _ in Reactor.Action.loadPriceList }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
        priceView.searchView.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceView.searchView.clearButton.rx.tap
            .map { Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceView.priceTableViewHeader.coinButton.rx.tap
            .map{ Reactor.Action.sortByCoin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceView.priceTableViewHeader.priceButton.rx.tap
            .map{ Reactor.Action.sortByPrice }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceView.priceTableViewHeader.changeButton.rx.tap
            .map{ Reactor.Action.sortByChange }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceView.priceTableViewHeader.gapButton.rx.tap
            .map{ Reactor.Action.sortByGap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceView.priceTableView.rx.itemSelected
            .map { Reactor.Action.selectCoin($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: PriceReactor){
        reactor.state.map{ $0.isTappedMarketButton }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] isTapped in
                if isTapped {
                    self?.priceView.priceCategoryView.marketButton.setTitleColor(ColorManager.common_0, for: .normal)
                    self?.reactor?.action.onNext(.loadPriceList)
                    self?.reactor?.action.onNext(.startTimer)
                    self?.priceView.priceCategoryView.editButton.isHidden = true
                }
                else{
                    self?.priceView.priceCategoryView.marketButton.setTitleColor(ColorManager.gray_80, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.isTappedFavoriteButton }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] isTapped in
                if isTapped {
                    self?.priceView.priceCategoryView.favoriteButton.setTitleColor(ColorManager.common_0, for: .normal)
                    self?.reactor?.action.onNext(.loadPriceList)
                    self?.reactor?.action.onNext(.startTimer)
                    self?.priceView.priceCategoryView.editButton.isHidden = false
                }
                else{
                    self?.priceView.priceCategoryView.favoriteButton.setTitleColor(ColorManager.gray_80, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.markets }
            .distinctUntilChanged()
            .bind(to: priceView.marketCollectionView.rx.items(cellIdentifier: "MarketListAtHomeCollectionViewCell", cellType: MarketListAtHomeCollectionViewCell.self)) { index, markets, cell in
                let isSelected = index == reactor.currentState.selectedMarket
                cell.isSelected = isSelected
                if isSelected {
                    self.priceView.marketCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                }
                cell.configure(with: markets)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredPriceList }
            .distinctUntilChanged()
            .bind(to: priceView.priceTableView.rx.items(cellIdentifier: "PriceTableViewCell", cellType: PriceTableViewCell.self)){ row, priceList, cell in
                
                cell.configure(with: priceList)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            reactor.state.map { $0.filteredPriceList }.distinctUntilChanged(),
            reactor.state.map { $0.searchText }.distinctUntilChanged()
        )
        .bind(onNext: { [weak self] filteredPriceList, searchText in
            if self?.reactor?.currentState.isTappedFavoriteButton == true {
                if filteredPriceList.isEmpty {
                    if searchText == "" {
                        self?.priceView.noneCoinView.isHidden = true
                        self?.priceView.noneFavoritesView.isHidden = false
                    } 
                    else {
                        self?.priceView.noneCoinView.isHidden = false
                        self?.priceView.noneFavoritesView.isHidden = true
                    }
                } 
                else {
                    self?.priceView.noneCoinView.isHidden = true
                    self?.priceView.noneFavoritesView.isHidden = true
                }
            } 
            else {
                self?.priceView.noneFavoritesView.isHidden = true
                if filteredPriceList.isEmpty {
                    self?.priceView.noneCoinView.isHidden = false
                } 
                else {
                    self?.priceView.noneCoinView.isHidden = true
                }
            }
        })
        .disposed(by: disposeBag)
        
        reactor.state.map{ $0.unit }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] unit in
                self?.priceView.priceTableViewHeader.priceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "시세 헤더",arguments: unit), for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.searchText }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.priceView.searchView.searchTextField.text = text
                if text == "" {
                    self?.priceView.searchView.clearButton.isHidden = true
                }
                else {
                    self?.priceView.searchView.clearButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.priceView.priceTableViewHeader.coinButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.priceView.priceTableViewHeader.coinButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.priceView.priceTableViewHeader.coinButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.priceSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.priceView.priceTableViewHeader.priceButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.priceView.priceTableViewHeader.priceButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.priceView.priceTableViewHeader.priceButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.changeSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.priceView.priceTableViewHeader.changeButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.priceView.priceTableViewHeader.changeButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.priceView.priceTableViewHeader.changeButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.gapSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.priceView.priceTableViewHeader.gapButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.priceView.priceTableViewHeader.gapButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.priceView.priceTableViewHeader.gapButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension PriceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        let text = (reactor?.currentState.markets[index].marketTitle) ?? ""
        let label = UILabel()
        label.text = text
        label.font = FontManager.H6_14
        label.numberOfLines = 1
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 34*ConstantsManager.standardHeight)
        let size = label.sizeThatFits(maxSize)
        return CGSize(width: (size.width+42)*ConstantsManager.standardWidth, height: 34*ConstantsManager.standardHeight)
    }
}

extension PriceViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = reactor?.currentState.markets[indexPath.item]
        let itemProvider = NSItemProvider(object: item?.marketTitle as? NSString ?? "")
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    self.reactor?.action.onNext(.moveItem(sourceIndexPath.item, destinationIndexPath.item))
                }, completion: { _ in
                    self.reactor?.action.onNext(.saveOrder)
                    let affectedIndexPaths = Array(min(sourceIndexPath.item, destinationIndexPath.item)...max(sourceIndexPath.item, destinationIndexPath.item)).map { IndexPath(item: $0, section: 0) }
                    collectionView.reloadItems(at: affectedIndexPaths)
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

extension PriceViewController {
    func setupScrollBehavior() {
        let headerHeight: CGFloat = priceView.priceCategoryView.frame.height + priceView.searchView.frame.height
        var lastOffsetY: CGFloat = 0
        var accumulatedOffsetY: CGFloat = 0
        
        priceView.priceTableView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                guard let self = self else { return }
                
                // 테이블 뷰의 셀 개수 확인
                let numberOfRows = self.priceView.priceTableView.numberOfRows(inSection: 0)
                
                // 셀 개수가 15개 이상일 때만 트랜스폼 적용
                if numberOfRows >= 15 {
                    let currentOffsetY = max(contentOffset.y, 0)
                    let deltaY = currentOffsetY - lastOffsetY
                    lastOffsetY = currentOffsetY
                    
                    accumulatedOffsetY = min(max(accumulatedOffsetY + deltaY, 0), headerHeight)
                    
                    self.priceView.priceCategoryView.transform = CGAffineTransform(translationX: 0, y: -accumulatedOffsetY)
                    self.priceView.searchView.transform = CGAffineTransform(translationX: 0, y: -accumulatedOffsetY)
                    
                    let headerTransform = CGAffineTransform(translationX: 0, y: -accumulatedOffsetY)
                    self.priceView.marketCollectionView.transform = headerTransform
                    self.priceView.priceTableViewHeader.transform = headerTransform
                    
                    let tableViewHeight = self.view.frame.height - self.view.safeAreaInsets.top + accumulatedOffsetY
                    self.priceView.priceTableView.frame.size.height = tableViewHeight
                    self.priceView.priceTableView.transform = CGAffineTransform(translationX: 0, y: -accumulatedOffsetY)
                } else {
                    // 셀 개수가 15개 미만일 때는 트랜스폼을 원래대로 복원
                    self.priceView.priceCategoryView.transform = .identity
                    self.priceView.searchView.transform = .identity
                    self.priceView.marketCollectionView.transform = .identity
                    self.priceView.priceTableViewHeader.transform = .identity
                    self.priceView.priceTableView.transform = .identity
                }
            })
            .disposed(by: disposeBag)
    }

}
