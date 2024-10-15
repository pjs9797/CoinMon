import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class SelectCoinViewAtAlarmController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let selectCoinAtAlarmView = SelectCoinAtAlarmView()
    
    init(with reactor: SelectCoinAtAlarmReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectCoinAtAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.selectCoinAtAlarmView.setLocalizedText()
            })
            .disposed(by: disposeBag)
        self.reactor?.action.onNext(.loadCoinData)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "코인 선택")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension SelectCoinViewAtAlarmController {
    func bind(reactor: SelectCoinAtAlarmReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectCoinAtAlarmReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtAlarmView.selectCoinTableView.rx.itemSelected
            .map { Reactor.Action.selectCoin($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtAlarmView.searchView.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtAlarmView.searchView.clearButton.rx.tap
            .map { Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtAlarmView.selectCoinTableViewHeader.coinButton.rx.tap
            .map{ Reactor.Action.sortByCoin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinAtAlarmView.selectCoinTableViewHeader.priceButton.rx.tap
            .map{ Reactor.Action.sortByPrice }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectCoinAtAlarmReactor){
        reactor.state.map { $0.filteredCoins }
            .distinctUntilChanged()
            .bind(to: selectCoinAtAlarmView.selectCoinTableView.rx.items(cellIdentifier: "SelectCoinTableViewCell", cellType: SelectCoinTableViewCell.self)){ row, coin, cell in
                
                cell.configurePrice(with: coin)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredCoins }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] filteredCoins in
                if filteredCoins.isEmpty {
                    self?.selectCoinAtAlarmView.noneCoinView.isHidden = false
                }
                else {
                    self?.selectCoinAtAlarmView.noneCoinView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.unit }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] unit in
                self?.selectCoinAtAlarmView.selectCoinTableViewHeader.priceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "시세 헤더", arguments: unit), for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.searchText }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.selectCoinAtAlarmView.searchView.searchTextField.text = text
                if text == "" {
                    self?.selectCoinAtAlarmView.searchView.clearButton.isHidden = true
                }
                else {
                    self?.selectCoinAtAlarmView.searchView.clearButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.selectCoinAtAlarmView.selectCoinTableViewHeader.coinButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.selectCoinAtAlarmView.selectCoinTableViewHeader.coinButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.selectCoinAtAlarmView.selectCoinTableViewHeader.coinButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.setPriceSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.selectCoinAtAlarmView.selectCoinTableViewHeader.priceButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.selectCoinAtAlarmView.selectCoinTableViewHeader.priceButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.selectCoinAtAlarmView.selectCoinTableViewHeader.priceButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}
