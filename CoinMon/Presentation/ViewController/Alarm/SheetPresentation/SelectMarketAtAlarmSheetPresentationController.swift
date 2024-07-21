import UIKit
import ReactorKit

class SelectMarketAtAlarmSheetPresentationController: CustomDimSheetPresentationController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectMarketView = SelectMarketView()
    
    init(with reactor: SelectMarketAtAlarmReactor) {
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

extension SelectMarketAtAlarmSheetPresentationController {
    func bind(reactor: SelectMarketAtAlarmReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectMarketAtAlarmReactor){
        selectMarketView.marketTableView.rx.itemSelected
            .map { Reactor.Action.selectMarket($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SelectMarketAtAlarmReactor){
        reactor.state.map { $0.markets }
            .distinctUntilChanged()
            .bind(to: selectMarketView.marketTableView.rx.items(cellIdentifier: "MarketTableViewCell", cellType: MarketTableViewCell.self)){ row, market, cell in
                
                cell.configure(with: market)
            }
            .disposed(by: disposeBag)
    }
}
