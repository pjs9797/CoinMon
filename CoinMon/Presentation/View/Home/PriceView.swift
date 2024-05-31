import UIKit
import SnapKit

class PriceView: UIView {
    let marketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8*Constants.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MarketListCollectionViewCell.self, forCellWithReuseIdentifier: "MarketListCollectionViewCell")
        return collectionView
    }()
    let searchView = SearchView()
    let priceTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 52*Constants.standardHeight
        tableView.register(PriceTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "PriceTableViewHeader")
        tableView.register(PriceTableViewCell.self, forCellReuseIdentifier: "PriceTableViewCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [marketCollectionView,searchView,priceTableView]
            .forEach{
                addSubview($0)
            }
        
        marketCollectionView.snp.makeConstraints { make in
            make.width.equalTo(355*Constants.standardWidth)
            make.height.equalTo(35*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(59*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        priceTableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
