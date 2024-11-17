import UIKit
import ReactorKit
import SnapKit

class SelectCoinForIndicatorViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let selectCoinForIndicatorView = SelectCoinForIndicatorView()
    
    init(with reactor: SelectCoinForIndicatorReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectCoinForIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        hideKeyboard(disposeBag: disposeBag)
        setNavigationbar()
        setKeyBoardNotificationCenter()
        self.reactor?.action.onNext(.loadIndicatorCoinPriceChange)
    }
    
    private func setNavigationbar() {
        self.title = ""
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setKeyBoardNotificationCenter() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] userInfo in
                if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                   let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                    let keyboardHeight = keyboardFrame.height
                    self?.selectCoinForIndicatorView.selectedCoinForIndicatorCollectionView.snp.remakeConstraints { make in
                        make.height.equalTo(46*ConstantsManager.standardHeight)
                        make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
                        make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
                        make.bottom.equalToSuperview()
                    }
                    self?.selectCoinForIndicatorView.selectedCoinForIndicatorCollectionView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .compactMap { $0.userInfo }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] userInfo in
                if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                    self?.selectCoinForIndicatorView.selectedCoinForIndicatorCollectionView.snp.remakeConstraints { make in
                        make.height.equalTo(46*ConstantsManager.standardHeight)
                        make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
                        make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
                        make.bottom.equalTo((self?.selectCoinForIndicatorView.buttonStackView.snp.top)!).offset(-8*ConstantsManager.standardHeight)
                    }
                    self?.selectCoinForIndicatorView.selectedCoinForIndicatorCollectionView.transform = .identity
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SelectCoinForIndicatorViewController {
    func bind(reactor: SelectCoinForIndicatorReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectCoinForIndicatorReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinForIndicatorView.explainButton.rx.tap
            .map{ Reactor.Action.explainButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinForIndicatorView.resetButton.rx.tap
            .map{ Reactor.Action.resetButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinForIndicatorView.selectedButton.rx.tap
            .map{ Reactor.Action.selectedButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinForIndicatorView.searchView.searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.updateSearchText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinForIndicatorView.searchView.clearButton.rx.tap
            .map { Reactor.Action.clearButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinForIndicatorView.coinForIndicatorTableViewHeader.coinButton.rx.tap
            .map{ Reactor.Action.sortByCoin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinForIndicatorView.coinForIndicatorTableViewHeader.priceButton.rx.tap
            .map{ Reactor.Action.sortByPrice }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectCoinForIndicatorView.coinForIndicatorTableViewHeader.changeButton.rx.tap
            .map{ Reactor.Action.sortByChange }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectCoinForIndicatorReactor){
        reactor.state.map{ $0.indicatorName }
            .bind(to: selectCoinForIndicatorView.indicatorLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ !$0.isPremium }
            .bind(to: selectCoinForIndicatorView.premiumLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredindicatorCoinPriceChangeList }
            .distinctUntilChanged()
            .bind(to: selectCoinForIndicatorView.coinForIndicatorTableView.rx.items(cellIdentifier: "CoinForIndicatorTableViewCell", cellType: CoinForIndicatorTableViewCell.self)){ row, list, cell in
                
                cell.configure(with: list)
                
                cell.checkButton.rx.tap
                    .flatMap { [weak self] _ -> Observable<Reactor.Action> in
                        if reactor.currentState.checkedCoinList.count >= 3 {
                            if list.isChecked == false {
                                self?.selectCoinForIndicatorView.toastMessage.isHidden = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self?.selectCoinForIndicatorView.toastMessage.isHidden = true
                                }
                                return Observable.empty()
                            }
                        }
                        return Observable.just(Reactor.Action.checkButtonTapped(indicatorCoinId: list.indicatorCoinId))
                    }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.filteredindicatorCoinPriceChangeList }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] filteredList in
                if filteredList.isEmpty {
                    self?.selectCoinForIndicatorView.noneCoinView.isHidden = false
                }
                else {
                    self?.selectCoinForIndicatorView.noneCoinView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.searchText }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                self?.selectCoinForIndicatorView.searchView.searchTextField.text = text
                if text == "" {
                    self?.selectCoinForIndicatorView.searchView.clearButton.isHidden = true
                }
                else {
                    self?.selectCoinForIndicatorView.searchView.clearButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.unit }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] unit in
                self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.priceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "시세 헤더",arguments: unit), for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.checkedCoinList }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: selectCoinForIndicatorView.selectedCoinForIndicatorCollectionView.rx.items(cellIdentifier: "SelectedCoinForIndicatorCollectionViewCell", cellType: SelectedCoinForIndicatorCollectionViewCell.self)) { index, data, cell in
                
                cell.configure(with: data.coinTitle)
                
                cell.deleteButton.rx.tap
                    .map { Reactor.Action.deleteButtonTapped(indicatorCoinId: data.indicatorCoinId) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.checkedCoinList }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] checkedCoinList in
                let isEmpty = checkedCoinList.isEmpty
                self?.selectCoinForIndicatorView.updateUIForSelectedCoins(isEmpty: isEmpty)
                self?.selectCoinForIndicatorView.selectedButton.setTitle(LocalizationManager.shared.localizedString(forKey: "선택 완료", arguments: "\(checkedCoinList.count)/3"), for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.coinButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.coinButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.coinButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.priceSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.priceButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.priceButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.priceButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.changeSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.changeButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.changeButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.selectCoinForIndicatorView.coinForIndicatorTableViewHeader.changeButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}
