import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class AlarmViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let alarmView = AlarmView()
    
    init(with reactor: AlarmReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = alarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        hideKeyboard(disposeBag: disposeBag)
        alarmView.marketCollectionView.dragDelegate = self
        alarmView.marketCollectionView.dropDelegate = self
        alarmView.marketCollectionView.dragInteractionEnabled = true
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.updateLocalizedMarkets)
                self?.alarmView.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.reactor?.action.onNext(.selectMarket(reactor?.currentState.selectedMarket ?? 0))
        self.reactor?.action.onNext(.updateSearchText(""))
    }
}

extension AlarmViewController {
    func bind(reactor: AlarmReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: AlarmReactor){
        alarmView.marketCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        alarmView.alarmTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        alarmView.addAlarmButton.rx.tap
            .map{ Reactor.Action.addAlarmButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        alarmView.marketCollectionView.rx.itemSelected
            .map { Reactor.Action.selectMarket($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        alarmView.alarmTableView.rx.itemSelected
            .map { Reactor.Action.alarmSelected($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        alarmView.searchView.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        alarmView.searchView.clearButton.rx.tap
            .map { Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        alarmView.alarmTableViewHeader.coinButton.rx.tap
            .map{ Reactor.Action.sortByCoin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        alarmView.alarmTableViewHeader.setPriceButton.rx.tap
            .map{ Reactor.Action.sortBySetPrice }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: AlarmReactor){
        reactor.state.map { $0.markets }
            .distinctUntilChanged()
            .bind(to: alarmView.marketCollectionView.rx.items(cellIdentifier: "MarketListCollectionViewCell", cellType: MarketListCollectionViewCell.self)) { index, markets, cell in
                let isSelected = index == reactor.currentState.selectedMarket
                cell.isSelected = isSelected
                if isSelected {
                    self.alarmView.marketCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                }
                cell.configure(with: markets)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.searchText }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.alarmView.searchView.searchTextField.text = text
                if text == "" {
                    self?.alarmView.searchView.clearButton.isHidden = true
                }
                else {
                    self?.alarmView.searchView.clearButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredAlarms }
            .distinctUntilChanged()
            .bind(to: alarmView.alarmTableView.rx.items(cellIdentifier: "AlarmTableViewCell", cellType: AlarmTableViewCell.self)) { (index, alarm, cell) in
                cell.configure(with: alarm)
                
                cell.alarmSwitch.rx.isOn.changed
                    .map { isOn in
                        Reactor.Action.toggleAlarmSwitch(alarm: alarm, isOn: isOn)
                    }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.unit }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] unit in
                self?.alarmView.alarmTableViewHeader.setPriceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "설정가 헤더", arguments: unit), for: .normal)
            })
            .disposed(by: disposeBag)
        
//        reactor.state.map{ $0.onCnt }
//            .distinctUntilChanged()
//            .bind(onNext: { [weak self] cnt in
//                if cnt == 20 {
//                    self?.alarmView.alarmTableViewHeader.onCntLabel.textColor = ColorManager.red_50
//                }
//                else {
//                    self?.alarmView.alarmTableViewHeader.onCntLabel.textColor = ColorManager.gray_50
//                }
//                var baseString = "💡 : \(cnt)"
//                self?.alarmView.alarmTableViewHeader.onCntLabel.text = baseString
//            })
//            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.totalCnt }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] cnt in
                if cnt == 0 {
                    self?.alarmView.noneAlarmView.isHidden = false
                }
                else {
                    self?.alarmView.noneAlarmView.isHidden = true
                }
                if cnt == 20 {
                    self?.alarmView.alarmTableViewHeader.totalCntLabel.textColor = ColorManager.red_50
                }
                else {
                    self?.alarmView.alarmTableViewHeader.totalCntLabel.textColor = ColorManager.gray_50
                }
                self?.alarmView.alarmTableViewHeader.totalCntLabel.text = "\(cnt) / 20"
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.alarmView.alarmTableViewHeader.coinButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.alarmView.alarmTableViewHeader.coinButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.alarmView.alarmTableViewHeader.coinButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.setPriceSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.alarmView.alarmTableViewHeader.setPriceButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.alarmView.alarmTableViewHeader.setPriceButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.alarmView.alarmTableViewHeader.setPriceButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isAlarmDeleted }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] show in
                if show {
                    self?.alarmView.completeDeleteAlarmToast.isHidden = false
                    self?.alarmView.completeDeleteAlarmToast.alpha = 1.0
                    UIView.animate(withDuration: 2.0, animations: {
                        self?.alarmView.completeDeleteAlarmToast.alpha = 0.0
                    }, completion: { _ in
                        self?.alarmView.completeDeleteAlarmToast.isHidden = true
                        self?.reactor?.action.onNext(.setAlarmDeleted(false))
                    })
                }
                else {
                    self?.alarmView.completeDeleteAlarmToast.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}

extension AlarmViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        let text = (reactor?.currentState.markets[index].marketTitle) ?? ""
        let label = UILabel()
        label.text = text
        label.font = FontManager.H6_14
        label.numberOfLines = 1
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 34*Constants.standardHeight)
        let size = label.sizeThatFits(maxSize)
        return CGSize(width: (size.width+42)*Constants.standardWidth, height: 34*Constants.standardHeight)
    }
}

extension AlarmViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
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

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: LocalizationManager.shared.localizedString(forKey: "삭제")) { [weak self] (action, view, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as? AlarmTableViewCell
            let alarmId = cell?.alarmId
            self?.reactor?.action.onNext(.deleteAlarm(alarmId ?? 0, indexPath.row))
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
