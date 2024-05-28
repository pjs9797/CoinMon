import UIKit
import ReactorKit

class PremiumViewController: UIViewController, ReactorKit.View, UIGestureRecognizerDelegate {
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
    }
}

extension PremiumViewController {
    func bind(reactor: PremiumReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PremiumReactor){
        premiumView.premiumTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        premiumView.departureExchangeButton.rx.tap
            .map{ Reactor.Action.departureExchangeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        premiumView.arrivalExchangeButton.rx.tap
            .map{ Reactor.Action.arrivalExchangeButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: PremiumReactor){
        reactor.state.map { $0.premiumList }
            .bind(to: premiumView.premiumTableView.rx.items(cellIdentifier: "FeePremiumTableViewCell", cellType: FeePremiumTableViewCell.self)){ row, premiumList, cell in
                
                cell.coinImageView.image = UIImage(named: premiumList.coinImage)
                cell.coinLabel.text = premiumList.coinTitle
                cell.feePremiumLabel.text = premiumList.premium
            }
            .disposed(by: disposeBag)
    }
}

extension PremiumViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PremiumTableViewHeader") as! PremiumTableViewHeader
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32*Constants.standardHeight
    }
}
