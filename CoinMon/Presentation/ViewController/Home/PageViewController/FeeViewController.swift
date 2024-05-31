import UIKit
import ReactorKit

class FeeViewController: UIViewController, ReactorKit.View {
    var disposeBag = DisposeBag()
    let feeView = FeeView()
    
    init(with reactor: FeeReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = feeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        hideKeyboard(disposeBag: disposeBag)
        feeView.marketCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        LocalizationManager.shared.rxLanguage
            .subscribe(onNext: { [weak self] _ in
                self?.reactor?.action.onNext(.updateLocalizedMarkets)
            })
            .disposed(by: disposeBag)
    }
}

extension FeeViewController {
    func bind(reactor: FeeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: FeeReactor){
        feeView.marketCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        feeView.feeTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        feeView.marketCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.feeView.marketCollectionView.cellForItem(at: indexPath) as? MarketListCollectionViewCell
                cell?.isSelected = true
            })
            .disposed(by: disposeBag)
        
        feeView.marketCollectionView.rx.itemDeselected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.feeView.marketCollectionView.cellForItem(at: indexPath) as? MarketListCollectionViewCell
                cell?.isSelected = false
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: FeeReactor){
        reactor.state.map { $0.markets }
            .distinctUntilChanged()
            .bind(to: feeView.marketCollectionView.rx.items(cellIdentifier: "MarketListCollectionViewCell", cellType: MarketListCollectionViewCell.self)) { index, markets, cell in
                cell.configure(with: markets)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.feeList }
            .bind(to: feeView.feeTableView.rx.items(cellIdentifier: "FeePremiumTableViewCell", cellType: FeePremiumTableViewCell.self)){ row, feeList, cell in
                cell.configureFee(with: feeList)
            }
            .disposed(by: disposeBag)
    }
}

extension FeeViewController: UICollectionViewDelegateFlowLayout {
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

extension FeeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FeeTableViewHeader") as! FeeTableViewHeader
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32*Constants.standardHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .white
    }
}
