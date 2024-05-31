import UIKit
import ReactorKit

class SelectMarketViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let selectMarketView = SelectMarketView()
    
    init(with reactor: SelectMarketReactor) {
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
        
        view.backgroundColor = .white
    }
}

extension SelectMarketViewController {
    func bind(reactor: SelectMarketReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectMarketReactor){
        
    }
    
    func bindState(reactor: SelectMarketReactor){
        reactor.state.map { $0.markets }
            .bind(to: selectMarketView.marketTableView.rx.items(cellIdentifier: "MarketTableViewCell", cellType: MarketTableViewCell.self)){ row, exchangeList, cell in
                
                cell.coinImageView.image = exchangeList.image
                cell.coinLabel.text = exchangeList.title
            }
            .disposed(by: disposeBag)
    }
}
