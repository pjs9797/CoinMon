import UIKit
import SnapKit

class EditFavoritesView: UIView {
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
    let favoritesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ColorManager.common_100
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "FavoritesTableViewCell")
        return tableView
    }()
    let deleteButton: BottomButton = {
        let button = BottomButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "삭제"), for: .normal)
        button.isNotEnable()
        return button
    }()
    let noneFavoritesView = NoneFavoritesView()
    
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
        noneFavoritesView.setLocalizedText()
    }
    
    private func layout() {
        [searchView,marketCollectionView,deleteButton,favoritesTableView,noneFavoritesView]
            .forEach{
                addSubview($0)
            }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(59*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        marketCollectionView.snp.makeConstraints { make in
            make.height.equalTo(35*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
        
        favoritesTableView.snp.makeConstraints { make in
            make.top.equalTo(marketCollectionView.snp.bottom).offset(8*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(deleteButton.snp.top).offset(-8*ConstantsManager.standardHeight)
        }
        
        noneFavoritesView.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(150*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(128*ConstantsManager.standardHeight)
        }
    }
}
