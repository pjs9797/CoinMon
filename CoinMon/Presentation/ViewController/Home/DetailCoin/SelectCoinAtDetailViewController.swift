import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SelectCoinAtDetailViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let selectCoinAtDetailView = SelectCoinAtDetailView()
    
    init(with reactor: SelectCoinAtDetailReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectCoinAtDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.selectCoinAtDetailView.setLocalizedText()
            })
            .disposed(by: disposeBag)
        self.reactor?.action.onNext(.loadCoinData)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "코인 선택")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension SelectCoinAtDetailViewController {
    func bind(reactor: SelectCoinAtDetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectCoinAtDetailReactor){
        selectCoinAtDetailView.marketCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        selectCoinAtDetailView.marketCollectionView.rx.itemSelected
            .map { Reactor.Action.selectMarket($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtDetailView.selectCoinTableView.rx.itemSelected
            .map { Reactor.Action.selectCoin($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtDetailView.searchView.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtDetailView.searchView.clearButton.rx.tap
            .map { Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtDetailView.selectCoinTableViewHeader.coinButton.rx.tap
            .map{ Reactor.Action.sortByCoin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtDetailView.selectCoinTableViewHeader.priceButton.rx.tap
            .map{ Reactor.Action.sortByPrice }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectCoinAtDetailReactor){
        reactor.state.map { $0.markets }
            .distinctUntilChanged()
            .bind(to: selectCoinAtDetailView.marketCollectionView.rx.items(cellIdentifier: "MarketListAtHomeCollectionViewCell", cellType: MarketListAtHomeCollectionViewCell.self)) { index, markets, cell in
                let isSelected = index == reactor.currentState.selectedMarket
                cell.isSelected = isSelected
                if isSelected {
                    self.selectCoinAtDetailView.marketCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
                }
                cell.configure(with: markets)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredCoins }
            .distinctUntilChanged()
            .bind(to: selectCoinAtDetailView.selectCoinTableView.rx.items(cellIdentifier: "SelectCoinTableViewCell", cellType: SelectCoinTableViewCell.self)){ row, coin, cell in
                
                cell.configurePrice(with: coin)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredCoins }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] filteredCoins in
                if filteredCoins.isEmpty {
                    self?.selectCoinAtDetailView.noneCoinView.isHidden = false
                }
                else {
                    self?.selectCoinAtDetailView.noneCoinView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.unit }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] unit in
                self?.selectCoinAtDetailView.selectCoinTableViewHeader.priceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "시세 헤더", arguments: unit), for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.searchText }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.selectCoinAtDetailView.searchView.searchTextField.text = text
                if text == "" {
                    self?.selectCoinAtDetailView.searchView.clearButton.isHidden = true
                }
                else {
                    self?.selectCoinAtDetailView.searchView.clearButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.selectCoinAtDetailView.selectCoinTableViewHeader.coinButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.selectCoinAtDetailView.selectCoinTableViewHeader.coinButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.selectCoinAtDetailView.selectCoinTableViewHeader.coinButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.setPriceSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.selectCoinAtDetailView.selectCoinTableViewHeader.priceButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.selectCoinAtDetailView.selectCoinTableViewHeader.priceButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.selectCoinAtDetailView.selectCoinTableViewHeader.priceButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SelectCoinAtDetailViewController: UICollectionViewDelegateFlowLayout {
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
