import UIKit
import SnapKit

class ThirdInfoView: UIView {
    let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "시세 변동")
        label.font = FontManager.D5_18
        label.textColor = ColorManager.common_0
        return label
    }()
    let priceChangeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 8*ConstantsManager.standardHeight, left: 4*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, right: 4*ConstantsManager.standardWidth)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width-44*ConstantsManager.standardWidth)/5, height: 46*ConstantsManager.standardHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = ColorManager.gray_99
        collectionView.layer.cornerRadius = 8*ConstantsManager.standardHeight
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PriceChangeCollectionViewCell.self, forCellWithReuseIdentifier: "PriceChangeCollectionViewCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorManager.common_100
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [priceChangeLabel,priceChangeCollectionView]
            .forEach{
                addSubview($0)
            }
        
        priceChangeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(23*ConstantsManager.standardHeight)
        }
        
        priceChangeCollectionView.snp.makeConstraints { make in
            make.height.equalTo(62*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(priceChangeLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-32*ConstantsManager.standardHeight)
        }
    }
}
