import UIKit
import SnapKit

class PriceView: UIView {
    let searchView = SearchView()
    let marketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8 * Constants.standardWidth
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20*Constants.standardWidth, bottom: 0, right: 20*Constants.standardWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MarketListCollectionViewCell.self, forCellWithReuseIdentifier: "MarketListCollectionViewCell")
        return collectionView
    }()
    let priceTableViewHeader = PriceTableViewHeader()
    let priceTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 52*Constants.standardHeight
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
    
    func setLocalizedText(){
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.gray_70 ?? UIColor.gray
        ]
        searchView.searchTextField.attributedPlaceholder = NSAttributedString(string: LocalizationManager.shared.localizedString(forKey: "코인 검색"), attributes: attributes)
        priceTableViewHeader.coinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인"), for: .normal)
        priceTableViewHeader.priceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "시세 헤더",arguments: "USDT"), for: .normal)
        priceTableViewHeader.changeButton.setTitle(LocalizationManager.shared.localizedString(forKey: "등락률"), for: .normal)
        priceTableViewHeader.gapButton.setTitle(LocalizationManager.shared.localizedString(forKey: "시평갭"), for: .normal)
    }
    
    private func layout() {
        [searchView,marketCollectionView,priceTableViewHeader,priceTableView]
            .forEach{
                addSubview($0)
            }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(59*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        marketCollectionView.snp.makeConstraints { make in
            make.height.equalTo(35*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        priceTableViewHeader.snp.makeConstraints { make in
            make.height.equalTo(32*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        priceTableView.snp.makeConstraints { make in
            make.top.equalTo(priceTableViewHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
