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
        
        view.backgroundColor = .white
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.premiumView.setLocalizedText()
            })
            .disposed(by: disposeBag)
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
    }
    
    func bindState(reactor: PremiumReactor){
        reactor.state.map { $0.premiumList }
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
    }
}
