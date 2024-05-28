import UIKit
import ReactorKit

class SelectExchangeViewController: UIViewController, ReactorKit.View, UIGestureRecognizerDelegate {
    var disposeBag = DisposeBag()
    let selectExchangeView = SelectExchangeView()
    
    init(with reactor: SelectExchangeReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = selectExchangeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
}

extension SelectExchangeViewController {
    func bind(reactor: SelectExchangeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SelectExchangeReactor){
        
    }
    
    func bindState(reactor: SelectExchangeReactor){
        reactor.state.map { $0.exchanges }
            .bind(to: selectExchangeView.exchangeTableView.rx.items(cellIdentifier: "ExchangeTableViewCell", cellType: ExchangeTableViewCell.self)){ row, exchangeList, cell in
                
                cell.coinImageView.image = exchangeList.image
                cell.coinLabel.text = exchangeList.title
            }
            .disposed(by: disposeBag)
    }
}
