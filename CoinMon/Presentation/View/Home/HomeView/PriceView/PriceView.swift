import UIKit
import SnapKit

class PriceView: UIView {
    let priceCategoryView = PriceCategoryView()
    let searchView = SearchView()
    let marketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8 * ConstantsManager.standardWidth
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20*ConstantsManager.standardWidth, bottom: 0, right: 20*ConstantsManager.standardWidth)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.common_100
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MarketListAtHomeCollectionViewCell.self, forCellWithReuseIdentifier: "MarketListAtHomeCollectionViewCell")
        return collectionView
    }()
    let priceTableViewHeader = PriceTableViewHeader()
    let priceTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ColorManager.common_100
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 52*ConstantsManager.standardHeight
        tableView.register(PriceTableViewCell.self, forCellReuseIdentifier: "PriceTableViewCell")
        return tableView
    }()
    let noneCoinView = NoneCoinView()
    let noneFavoritesView = NoneFavoritesView()
    let toastMessage: ToastMessageView = {
        let view = ToastMessageView(message: LocalizationManager.shared.localizedString(forKey: "편집 내용이 저장되었어요"))
        view.isHidden = true
        return view
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
        noneCoinView.setLocalizedText()
        noneFavoritesView.setLocalizedText()
        priceCategoryView.setLocalizedText()
    }
    
    private func layout() {
        [priceCategoryView,searchView,marketCollectionView,priceTableViewHeader,priceTableView,noneCoinView,noneFavoritesView,toastMessage]
            .forEach{
                addSubview($0)
            }
        
        priceCategoryView.snp.makeConstraints { make in
            make.height.equalTo(38*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(59*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(priceCategoryView.snp.bottom)
        }
        
        marketCollectionView.snp.makeConstraints { make in
            make.height.equalTo(35*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        priceTableViewHeader.snp.makeConstraints { make in
            make.height.equalTo(32*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(marketCollectionView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        priceTableView.snp.makeConstraints { make in
            make.top.equalTo(priceTableViewHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        noneCoinView.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(150*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(priceTableViewHeader.snp.bottom).offset(120*ConstantsManager.standardHeight)
        }
        
        noneFavoritesView.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(150*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(priceTableViewHeader.snp.bottom).offset(120*ConstantsManager.standardHeight)
        }
        
        toastMessage.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20*ConstantsManager.standardHeight)
        }
    }
}
