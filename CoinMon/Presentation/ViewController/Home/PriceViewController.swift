import UIKit
import ReactorKit

class PriceViewController: UIViewController, ReactorKit.View, UIGestureRecognizerDelegate {
    var disposeBag = DisposeBag()
    let priceView = PriceView()
    
    init(with reactor: PriceReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = priceView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        hideKeyboard(delegate: self, disposeBag: disposeBag)
    }
}

extension PriceViewController {
    func bind(reactor: PriceReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PriceReactor){
        priceView.exchangeCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        priceView.priceTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        priceView.exchangeCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.priceView.exchangeCollectionView.cellForItem(at: indexPath) as? ExchangeListCollectionViewCell
                cell?.isSelected = true
            })
            .disposed(by: disposeBag)
        
        priceView.exchangeCollectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.priceView.exchangeCollectionView.cellForItem(at: indexPath) as? ExchangeListCollectionViewCell
                cell?.isSelected = false
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: PriceReactor){
        reactor.state.map { $0.exchanges }
            .distinctUntilChanged()
            .bind(to: priceView.exchangeCollectionView.rx.items(cellIdentifier: "ExchangeListCollectionViewCell", cellType: ExchangeListCollectionViewCell.self)) { index, exchanges, cell in
                cell.exchangeImageView.image = exchanges.image
                cell.exchangeLabel.text = exchanges.title
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.priceList }
            .bind(to: priceView.priceTableView.rx.items(cellIdentifier: "PriceTableViewCell", cellType: PriceTableViewCell.self)){ row, priceList, cell in
                
                cell.coinImageView.image = UIImage(named: priceList.coinImage)
                cell.coinLabel.text = priceList.coinTitle
                cell.priceLabel.text = priceList.price
                cell.changeLabel.text = priceList.change
                cell.gapLabel.text = priceList.gap
            }
            .disposed(by: disposeBag)
    }
}

extension PriceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        let text = (reactor?.currentState.exchanges[index].title) ?? ""
        let label = UILabel()
        label.text = text
        label.font = FontManager.H6_14
        label.numberOfLines = 1
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 34*Constants.standardHeight)
        let size = label.sizeThatFits(maxSize)
        return CGSize(width: (size.width+42)*Constants.standardWidth, height: 34*Constants.standardHeight)
    }
}

extension PriceViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PriceTableViewHeader") as! PriceTableViewHeader
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32*Constants.standardHeight
    }
}
