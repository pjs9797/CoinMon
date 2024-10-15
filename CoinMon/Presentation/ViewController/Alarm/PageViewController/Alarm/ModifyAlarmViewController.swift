import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class ModifyAlarmViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let backButton = UIBarButtonItem(image: ImageManager.arrow_Chevron_Left, style: .plain, target: nil, action: nil)
    let deleteButton = UIBarButtonItem(title: LocalizationManager.shared.localizedString(forKey: "삭제"), style: .plain, target: nil, action: nil)
    let addAlarmView = AddAlarmView()
    
    init(with reactor: ModifyAlarmReactor) {
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
        
        view.backgroundColor = .systemBackground
        setNavigationbar()
        hideKeyboard(disposeBag: disposeBag)
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.addAlarmView.setLocalizedText()
            })
            .disposed(by: disposeBag)
        self.reactor?.action.onNext(.updateCurrentPrice)
    }
    
    private func setNavigationbar() {
        self.title = LocalizationManager.shared.localizedString(forKey: "알람 수정")
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.T3_16,
            .foregroundColor: ColorManager.gray_15 ?? .black,
        ]
        deleteButton.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = deleteButton
    }
}

extension ModifyAlarmViewController {
    func bind(reactor: ModifyAlarmReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: ModifyAlarmReactor){
        backButton.rx.tap
            .map{ Reactor.Action.backButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .map{ Reactor.Action.deleteButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addAlarmView.setPriceTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                let text = self?.reactor?.filterPrice(price: text)
                self?.addAlarmView.setPriceTextField.text = text
                reactor.action.onNext(.updateSetPrice(text ?? ""))
            })
            .disposed(by: disposeBag)
        
        addAlarmView.comparePriceButton.rx.tap
            .map{ Reactor.Action.comparePriceButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addAlarmView.cycleButton.rx.tap
            .map{ Reactor.Action.cycleButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addAlarmView.completeButton.rx.tap
            .map{ Reactor.Action.completeButtonTapped }
            .bind(to: reactor.action)
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
    
    func bindState(reactor: ModifyAlarmReactor){
        reactor.state.map{ $0.market }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] market in
                self?.addAlarmView.marketButton.setTitle(LocalizationManager.shared.localizedString(forKey: market), for: .normal)
                self?.addAlarmView.marketButton.setTitleColor(ColorManager.common_0, for: .normal)
                self?.addAlarmView.marketButton.setImage(UIImage(named: market)?.resizeTo20(), for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinTitle }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] coin in
                self?.addAlarmView.coinButton.setTitle(coin, for: .normal)
                self?.addAlarmView.coinButton.setTitleColor(ColorManager.common_0, for: .normal)
                
                self?.addAlarmView.coinButton.setImage(UIImage(named: coin)?.resizeTo20() ?? ImageManager.login_coinmon?.resizeTo20(), for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.currentPrice }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] price in
                self?.addAlarmView.currentCoinPriceLabel.text = reactor.formatPrice(price)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.currentPriceUnit }
            .distinctUntilChanged()
            .bind(to: self.addAlarmView.currentCoinPriceUnitLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.setPrice }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] price in
                self?.addAlarmView.setPriceTextField.text = reactor.formatPrice(price)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.setPriceUnit }
            .distinctUntilChanged()
            .bind(to: self.addAlarmView.setPriceUnitLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.comparePrice }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] condition in
                if let condition = condition {
                    self?.addAlarmView.comparePriceButton.setTitle("\(condition)%", for: .normal)
                    self?.addAlarmView.comparePriceButton.setTitleColor(ColorManager.common_0, for: .normal)
                }
                else {
                    self?.addAlarmView.comparePriceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "선택"), for: .normal)
                    self?.addAlarmView.comparePriceButton.setTitleColor(ColorManager.gray_90, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.cycle }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] condition in
                self?.addAlarmView.cycleButton.setTitle(LocalizationManager.shared.localizedString(forKey: condition), for: .normal)
                self?.addAlarmView.cycleButton.setTitleColor(ColorManager.common_0, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
