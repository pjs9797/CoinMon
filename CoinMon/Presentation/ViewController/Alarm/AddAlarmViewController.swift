import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class AddAlarmViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let addAlarmView = AddAlarmView()
    
    init(with reactor: AddAlarmReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = addAlarmView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.addAlarmView.setLocalizedText()
            })
            .disposed(by: disposeBag)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "알람 추가")
        navigationItem.leftBarButtonItem = backButton
    }
}

extension AddAlarmViewController {
    func bind(reactor: AddAlarmReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: AddAlarmReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addAlarmView.marketButton.rx.tap
            .map{ Reactor.Action.marketButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addAlarmView.coinButton.rx.tap
            .map{ Reactor.Action.coinButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addAlarmView.setPriceTextField.rx.text.orEmpty
            .map{ Reactor.Action.updateSetPrice($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addAlarmView.comparePriceButton.rx.tap
            .map{ Reactor.Action.comparePriceButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addAlarmView.cycleButton.rx.tap
            .map{ Reactor.Action.cycleButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.selectMarketRelay
            .bind(onNext: { selectedMarket in
                reactor.action.onNext(.setMarket(selectedMarket))
            })
            .disposed(by: disposeBag)
        
        reactor.selectCoinRelay
            .bind(onNext: { selectedCoin in
                reactor.action.onNext(.setCoin(selectedCoin.0, selectedCoin.1))
            })
            .disposed(by: disposeBag)
        
        reactor.selectFirstAlarmConditionRelay
            .bind(onNext: { condition in
                reactor.action.onNext(.setComparePrice(condition))
            })
            .disposed(by: disposeBag)
        
        reactor.selectSecondAlarmConditionRelay
            .bind(onNext: { condition in
                reactor.action.onNext(.setCycle(condition))
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindState(reactor: AddAlarmReactor){
        reactor.state.map{ $0.market }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] market in
                if let market = market {
                    self?.addAlarmView.marketButton.setTitle(LocalizationManager.shared.localizedString(forKey: market), for: .normal)
                    self?.addAlarmView.marketButton.setTitleColor(ColorManager.common_0, for: .normal)
                    self?.addAlarmView.marketButton.setImage(UIImage(named: market), for: .normal)
                    self?.addAlarmView.coinButton.isEnabled = true
                }
                else {
                    self?.addAlarmView.marketButton.setTitle(LocalizationManager.shared.localizedString(forKey: "선택"), for: .normal)
                    self?.addAlarmView.marketButton.setTitleColor(ColorManager.gray_90, for: .normal)
                    self?.addAlarmView.coinButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinTitle }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] coin in
                if let coin = coin {
                    self?.addAlarmView.coinButton.setTitle(coin, for: .normal)
                    self?.addAlarmView.coinButton.setTitleColor(ColorManager.common_0, for: .normal)
                    self?.addAlarmView.coinButton.setImage(UIImage(named: coin), for: .normal)
                    self?.addAlarmView.setPriceTextField.isEnabled = true
                    self?.addAlarmView.comparePriceButton.isEnabled = true
                }
                else {
                    self?.addAlarmView.coinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "선택"), for: .normal)
                    self?.addAlarmView.coinButton.setTitleColor(ColorManager.gray_90, for: .normal)
                    self?.addAlarmView.setPriceTextField.isEnabled = false
                    self?.addAlarmView.comparePriceButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.currentPrice }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] price in
                if let price = price {
                    self?.addAlarmView.currentCoinPriceLabel.text = price
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.setPrice }
            .bind(onNext: { [weak self] price in
                if let price = price {
                    self?.addAlarmView.setPriceTextField.text = price
                }
                else {
                    self?.addAlarmView.setPriceTextField.placeholder = LocalizationManager.shared.localizedString(forKey: "선택")
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.comparePrice }
            .bind(onNext: { [weak self] condition in
                if let condition = condition {
                    self?.addAlarmView.comparePriceButton.setTitle(LocalizationManager.shared.localizedString(forKey: condition), for: .normal)
                    self?.addAlarmView.comparePriceButton.setTitleColor(ColorManager.common_0, for: .normal)
                }
                else {
                    self?.addAlarmView.comparePriceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "선택"), for: .normal)
                    self?.addAlarmView.comparePriceButton.setTitleColor(ColorManager.gray_90, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.cycle }
            .bind(onNext: { [weak self] condition in
                if let condition = condition {
                    self?.addAlarmView.cycleButton.setTitle(LocalizationManager.shared.localizedString(forKey: condition), for: .normal)
                    self?.addAlarmView.cycleButton.setTitleColor(ColorManager.common_0, for: .normal)
                }
                else {
                    self?.addAlarmView.cycleButton.setTitle(LocalizationManager.shared.localizedString(forKey: "선택"), for: .normal)
                    self?.addAlarmView.cycleButton.setTitleColor(ColorManager.gray_90, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}
