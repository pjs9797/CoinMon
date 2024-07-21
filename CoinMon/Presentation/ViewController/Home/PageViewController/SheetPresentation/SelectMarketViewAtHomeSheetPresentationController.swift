import UIKit
import ReactorKit

class SelectMarketViewAtHomeSheetPresentationController: CustomDimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectMarketView = SelectMarketView()
    
    init(with reactor: SelectMarketAtHomeReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectMarketView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
}

extension SelectMarketViewAtHomeSheetPresentationController {
    func bind(reactor: SelectMarketAtHomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectMarketAtHomeReactor){
        selectMarketView.marketTableView.rx.itemSelected
            .map { Reactor.Action.selectMarket($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectMarketView.marketTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                if let cell = self.selectMarketView.marketTableView.cellForRow(at: indexPath) as? MarketTableViewCell {
                    cell.checkImageView.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectMarketAtHomeReactor){
        reactor.state.map { $0.markets }
            .distinctUntilChanged()
            .bind(to: selectMarketView.marketTableView.rx.items(cellIdentifier: "MarketTableViewCell", cellType: MarketTableViewCell.self)){ row, market, cell in
                
                cell.configure(with: market)
            }
            .disposed(by: disposeBag)
    }
}
