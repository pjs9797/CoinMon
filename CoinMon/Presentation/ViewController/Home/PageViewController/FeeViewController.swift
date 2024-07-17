import UIKit
import ReactorKit

class FeeViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let feeView = FeeView()
    
    init(with reactor: FeeReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = feeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        hideKeyboard(disposeBag: disposeBag)
        feeView.marketCollectionView.dragDelegate = self
        feeView.marketCollectionView.dropDelegate = self
        feeView.marketCollectionView.dragInteractionEnabled = true
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.updateLocalizedMarkets)
                self?.feeView.setLocalizedText()
            })
            .disposed(by: disposeBag)
        self.reactor?.action.onNext(.loadFeeList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reactor?.action.onNext(.startTimer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        reactor?.action.onNext(.stopTimer)
    }
}

extension FeeViewController {
    func bind(reactor: FeeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: FeeReactor){
        feeView.marketCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        feeView.marketCollectionView.rx.itemSelected
            .map { Reactor.Action.selectMarket($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        feeView.searchView.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        feeView.searchView.clearButton.rx.tap
            .map { Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        feeView.feeTableViewHeader.coinButton.rx.tap
            .map{ Reactor.Action.sortByCoin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        feeView.feeTableViewHeader.feeButton.rx.tap
            .map{ Reactor.Action.sortByFee }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: FeeReactor){
        reactor.state.map { $0.markets }
            .distinctUntilChanged()
            .bind(to: feeView.marketCollectionView.rx.items(cellIdentifier: "MarketListAtHomeCollectionViewCell", cellType: MarketListAtHomeCollectionViewCell.self)) { index, markets, cell in
                let isSelected = index == reactor.currentState.selectedMarket
                cell.isSelected = isSelected
                if isSelected {
                    self.feeView.marketCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                }
                cell.configure(with: markets)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredFeeList }
            .bind(to: feeView.feeTableView.rx.items(cellIdentifier: "FeePremiumTableViewCell", cellType: FeePremiumTableViewCell.self)){ row, feeList, cell in
                cell.configureFee(with: feeList)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.searchText }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.feeView.searchView.searchTextField.text = text
                if text == "" {
                    self?.feeView.searchView.clearButton.isHidden = true
                }
                else {
                    self?.feeView.searchView.clearButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.feeView.feeTableViewHeader.coinButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.feeView.feeTableViewHeader.coinButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.feeView.feeTableViewHeader.coinButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.feeSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.feeView.feeTableViewHeader.feeButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.feeView.feeTableViewHeader.feeButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.feeView.feeTableViewHeader.feeButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension FeeViewController: UICollectionViewDelegateFlowLayout {
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

extension FeeViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
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
