import UIKit
import ReactorKit

class SelectMarketViewAtHomeController: UIViewController, ReactorKit.View {
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
        
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let sheet = self.sheetPresentationController {
            DispatchQueue.main.async {
                if let containerView = sheet.containerView {
                    if let dimmingView = containerView.subviews.first(where: { $0.isUserInteractionEnabled }) {
                        UIView.transition(with: dimmingView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                        }, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let sheet = self.sheetPresentationController {
            if let containerView = sheet.containerView {
                if let dimmingView = containerView.subviews.first(where: { $0.isUserInteractionEnabled }) {
                    UIView.transition(with: dimmingView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        dimmingView.backgroundColor = UIColor.clear
                    }, completion: nil)
                }
            }
        }
    }
}

extension SelectMarketViewAtHomeController {
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
