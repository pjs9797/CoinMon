import UIKit
import SnapKit

class PriceView: UIView {
    let exchangeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8*Constants.standardWidth
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ExchangeListCollectionViewCell.self, forCellWithReuseIdentifier: "ExchangeListCollectionViewCell")
        return collectionView
    }()
    let searchView = SearchView()
    let tableView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [exchangeCollectionView,searchView,tableView]
            .forEach{
                addSubview($0)
            }
        exchangeCollectionView.snp.makeConstraints { make in
            make.width.equalTo(355*Constants.standardWidth)
            make.height.equalTo(35*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
        }
        
        searchView.snp.makeConstraints { make in
            make.height.equalTo(59*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(exchangeCollectionView.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
