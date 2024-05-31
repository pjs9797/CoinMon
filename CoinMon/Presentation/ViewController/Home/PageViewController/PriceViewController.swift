import UIKit
import ReactorKit

class PriceViewController: UIViewController, ReactorKit.View {
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
        hideKeyboard(disposeBag: disposeBag)
        priceView.marketCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.updateLocalizedMarkets)
            })
            .disposed(by: disposeBag)
    }
}

extension PriceViewController {
    func bind(reactor: PriceReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: PriceReactor){
        priceView.marketCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        priceView.priceTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        priceView.marketCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.priceView.marketCollectionView.cellForItem(at: indexPath) as? MarketListCollectionViewCell
                cell?.isSelected = true
            })
            .disposed(by: disposeBag)
        
        priceView.marketCollectionView.rx.itemDeselected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.priceView.marketCollectionView.cellForItem(at: indexPath) as? MarketListCollectionViewCell
                cell?.isSelected = false
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: PriceReactor){
        reactor.state.map { $0.markets }
            .distinctUntilChanged()
            .bind(to: priceView.marketCollectionView.rx.items(cellIdentifier: "MarketListCollectionViewCell", cellType: MarketListCollectionViewCell.self)) { index, markets, cell in
                cell.configure(with: markets)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.priceList }
            .bind(to: priceView.priceTableView.rx.items(cellIdentifier: "PriceTableViewCell", cellType: PriceTableViewCell.self)){ row, priceList, cell in
                cell.configure(with: priceList)
            }
            .disposed(by: disposeBag)
    }
}

extension PriceViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        let text = (reactor?.currentState.markets[index].title) ?? ""
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
