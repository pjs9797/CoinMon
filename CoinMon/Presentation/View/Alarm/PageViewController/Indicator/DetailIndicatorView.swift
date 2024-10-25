import UIKit
import SnapKit

class DetailIndicatorView: UIView {
    let indicatorCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width-40*ConstantsManager.standardWidth)/3, height: 34*ConstantsManager.standardHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DetailCoinInfoCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCoinInfoCategoryCollectionViewCell")
        return collectionView
    }()
    let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_98
        return view
    }()
    let explanIndicatorTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(ExplanIndicatorTableViewCell.self, forCellReuseIdentifier: "ExplanIndicatorTableVieCell")
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
        [grayView,indicatorCategoryCollectionView,explanIndicatorTableView]
            .forEach{
                addSubview($0)
            }
        
        indicatorCategoryCollectionView.snp.makeConstraints { make in
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        grayView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(indicatorCategoryCollectionView.snp.bottom)
        }
        
        explanIndicatorTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(grayView.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
