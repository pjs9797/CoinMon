import UIKit
import SnapKit

class FeeView: UIView {
    let searchView = SearchView()
    let marketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8*ConstantsManager.standardWidth
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20*ConstantsManager.standardWidth, bottom: 0, right: 20*ConstantsManager.standardWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.common_100
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MarketListAtHomeCollectionViewCell.self, forCellWithReuseIdentifier: "MarketListAtHomeCollectionViewCell")
        return collectionView
    }()
    let feeTableViewHeader = FeeTableViewHeader()
    let feeTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ColorManager.common_100
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 52*ConstantsManager.standardHeight
        tableView.register(FeePremiumTableViewCell.self, forCellReuseIdentifier: "FeePremiumTableViewCell")
        return tableView
    }()
    let noneCoinView = NoneCoinView()
    
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
        feeTableViewHeader.coinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인"), for: .normal)
        feeTableViewHeader.feeButton.setTitle(LocalizationManager.shared.localizedString(forKey: "펀비"), for: .normal)
        noneCoinView.setLocalizedText()
    }
    
    private func layout() {
        [marketCollectionView,searchView,feeTableViewHeader,feeTableView,noneCoinView]
            .forEach{
                addSubview($0)
            }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(59*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        marketCollectionView.snp.makeConstraints { make in
            make.height.equalTo(35*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        feeTableViewHeader.snp.makeConstraints { make in
            make.height.equalTo(32*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        feeTableView.snp.makeConstraints { make in
            make.top.equalTo(feeTableViewHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        noneCoinView.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(150*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(feeTableViewHeader.snp.bottom).offset(120*ConstantsManager.standardHeight)
        }
    }
}
