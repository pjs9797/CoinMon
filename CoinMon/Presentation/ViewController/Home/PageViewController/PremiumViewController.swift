import UIKit
import ReactorKit

class PremiumViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let premiumView = PremiumView()
    
    init(with reactor: PremiumReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = premiumView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.premiumView.setLocalizedText()
            })
            .disposed(by: disposeBag)
        self.reactor?.action.onNext(.loadPremiumList)
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

extension PremiumViewController {
    func bind(reactor: PremiumReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PremiumReactor){
        premiumView.departureMarketButton.rx.tap
            .map{ Reactor.Action.departureMarketButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        premiumView.arrivalMarketButton.rx.tap
            .map{ Reactor.Action.arrivalMarketButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.selectDepartureMarketRelay
            .bind(onNext: { selectedMarket in
                reactor.action.onNext(.setDepartureMarket(selectedMarket))
            })
            .disposed(by: disposeBag)
        
        reactor.selectArrivalMarketRelay
            .bind(onNext: { selectedMarket in
                reactor.action.onNext(.setArrivalMarket(selectedMarket))
            })
            .disposed(by: disposeBag)
        
        premiumView.premiumTableViewHeader.coinButton.rx.tap
            .map{ Reactor.Action.sortByCoin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        premiumView.premiumTableViewHeader.premiumButton.rx.tap
            .map{ Reactor.Action.sortByPremium }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: PremiumReactor){
        reactor.state.map { $0.filteredpremiumList }
            .distinctUntilChanged()
            .bind(to: premiumView.premiumTableView.rx.items(cellIdentifier: "FeePremiumTableViewCell", cellType: FeePremiumTableViewCell.self)){ row, premiumList, cell in
                cell.configurePremium(with: premiumList)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.departureMarketButtonTitle }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] title in
                self?.premiumView.departureMarketButton.leftImageView.image = UIImage(named: title)
                self?.premiumView.departureMarketButton.setTitle(LocalizationManager.shared.localizedString(forKey: title), for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.arrivalMarketButtonTitle }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] title in
                self?.premiumView.arrivalMarketButton.leftImageView.image = UIImage(named: title)
                self?.premiumView.arrivalMarketButton.setTitle(LocalizationManager.shared.localizedString(forKey: title), for: .normal)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.coinSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.premiumView.premiumTableViewHeader.coinButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.premiumView.premiumTableViewHeader.coinButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.premiumView.premiumTableViewHeader.coinButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.premiumSortOrder }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] order in
                switch order{
                case .ascending:
                    self?.premiumView.premiumTableViewHeader.premiumButton.setImage(ImageManager.sort_ascending, for: .normal)
                case .descending:
                    self?.premiumView.premiumTableViewHeader.premiumButton.setImage(ImageManager.sort_descending, for: .normal)
                case .none:
                    self?.premiumView.premiumTableViewHeader.premiumButton.setImage(ImageManager.sort, for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}
