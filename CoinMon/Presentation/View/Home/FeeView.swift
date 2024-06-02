import UIKit
import SnapKit

class FeeView: UIView {
    let marketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8*Constants.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MarketListCollectionViewCell.self, forCellWithReuseIdentifier: "MarketListCollectionViewCell")
        return collectionView
    }()
    let searchView = SearchView()
    let feeTableViewHeader = FeeTableViewHeader()
    let feeTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 52*Constants.standardHeight
        tableView.register(FeePremiumTableViewCell.self, forCellReuseIdentifier: "FeePremiumTableViewCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        searchView.searchTextField.placeholder = LocalizationManager.shared.localizedString(forKey: "코인 검색")
        feeTableViewHeader.coinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인"), for: .normal)
        feeTableViewHeader.feeButton.setTitle(LocalizationManager.shared.localizedString(forKey: "펀비"), for: .normal)
    }
    
    private func layout() {
        [marketCollectionView,searchView,feeTableViewHeader,feeTableView]
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
        
        feeTableViewHeader.snp.makeConstraints { make in
            make.height.equalTo(32*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
        
        feeTableView.snp.makeConstraints { make in
            make.top.equalTo(feeTableViewHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
