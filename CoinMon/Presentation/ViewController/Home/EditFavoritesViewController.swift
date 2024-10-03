import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class EditFavoritesViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    let editFavoritesView = EditFavoritesView()
    
    init(with reactor: EditFavoritesReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = editFavoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.editFavoritesView.setLocalizedText()
            })
            .disposed(by: disposeBag)
        self.reactor?.action.onNext(.loadFavoritesData)
        
        self.editFavoritesView.favoritesTableView.setEditing(true, animated: true)
        self.editFavoritesView.favoritesTableView.allowsSelectionDuringEditing = true
        self.setupNotifications()
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "편집")
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupNotifications() {
        NotificationCenter.default.rx.notification(.marketStayed)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                let index = self?.reactor?.currentState.selectedMarket ?? 0
                self?.editFavoritesView.marketCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.marketSelected)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.notificationMarketSelected)
            })
            .disposed(by: disposeBag)
    }
}

extension EditFavoritesViewController {
    func bind(reactor: EditFavoritesReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: EditFavoritesReactor){
        editFavoritesView.marketCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        editFavoritesView.favoritesTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        editFavoritesView.marketCollectionView.rx.itemSelected
            .withLatestFrom(reactor.state.map { $0.selectedMarket }) { (indexPath, selectedMarket) in
                (indexPath.item, selectedMarket)
            }
            .filter { selectedItem, selectedMarket in
                selectedItem != selectedMarket
            }
            .map { selectedItem, _ in
                Reactor.Action.selectMarket(selectedItem)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .map{ Reactor.Action.saveButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editFavoritesView.deleteButton.rx.tap
            .map{ Reactor.Action.deleteButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editFavoritesView.searchView.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editFavoritesView.searchView.clearButton.rx.tap
            .map { Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editFavoritesView.favoritesTableView.rx.itemMoved
            .filter { $0.sourceIndex.row != 0 && $0.destinationIndex.row != 0 }
            .map { Reactor.Action.moveFavorite(from: $0.sourceIndex.row, to: $0.destinationIndex.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editFavoritesView.favoritesTableView.rx.willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                if indexPath.row == 0 {
                    cell.showsReorderControl = false
                } else {
                    cell.showsReorderControl = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: EditFavoritesReactor){
        reactor.state.map { $0.markets }
            .distinctUntilChanged()
            .bind(to: editFavoritesView.marketCollectionView.rx.items(cellIdentifier: "MarketListAtHomeCollectionViewCell", cellType: MarketListAtHomeCollectionViewCell.self)) { index, markets, cell in
                let isSelected = index == reactor.currentState.selectedMarket
                cell.isSelected = isSelected
                if isSelected {
                    self.editFavoritesView.marketCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                }
                cell.configure(with: markets)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredFavorites }
            .distinctUntilChanged()
            .bind(to: editFavoritesView.favoritesTableView.rx.items(cellIdentifier: "FavoritesTableViewCell", cellType: FavoritesTableViewCell.self)){ row, favorites, cell in
                let isFirst = row == 0
                cell.configure(with: favorites.symbol, isFirst: isFirst, isChecked: favorites.isSelected)
                
                cell.checkButton.rx.tap
                    .map { Reactor.Action.toggleFavorite(row) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredFavorites }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] filteredFavorites in
                if filteredFavorites.count == 1 || filteredFavorites.count == 0 {
                    self?.editFavoritesView.favoritesTableView.isHidden = true
                    self?.editFavoritesView.noneFavoritesView.isHidden = false
                    self?.editFavoritesView.deleteButton.isHidden = true
                }
                else {
                    self?.editFavoritesView.favoritesTableView.isHidden = false
                    self?.editFavoritesView.noneFavoritesView.isHidden = true
                    self?.editFavoritesView.deleteButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.searchText }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.editFavoritesView.searchView.searchTextField.text = text
                if text == "" {
                    self?.editFavoritesView.searchView.clearButton.isHidden = true
                }
                else {
                    self?.editFavoritesView.searchView.clearButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.isDataChanged }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isDataChanged in
                var attributes: [NSAttributedString.Key: Any] = [:]
                if isDataChanged {
                    attributes = [
                        .font: FontManager.T3_16,
                        .foregroundColor: ColorManager.gray_15!
                    ]
                } else {
                    attributes = [
                        .font: FontManager.T3_16,
                        .foregroundColor: ColorManager.gray_90!
                    ]
                }
                
                self?.saveButton.setTitleTextAttributes(attributes, for: .normal)
                self?.saveButton.isEnabled = isDataChanged
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isDeleteButtonEnabled }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] isEnable in
                if isEnable {
                    self?.editFavoritesView.deleteButton.isEnable()
                }
                else {
                    self?.editFavoritesView.deleteButton.isNotEnable()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension EditFavoritesViewController: UICollectionViewDelegateFlowLayout {
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

extension EditFavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return IndexPath(row: 1, section: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
}
