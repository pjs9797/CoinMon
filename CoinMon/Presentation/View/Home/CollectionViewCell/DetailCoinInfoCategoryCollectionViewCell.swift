import UIKit
import SnapKit

class DetailCoinInfoCategoryCollectionViewCell: UICollectionViewCell {
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H4_16
        label.textColor = ColorManager.gray_80
        label.textAlignment = .center
        return label
    }()
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_98
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateUI()
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        categoryLabel.textColor = isSelected ? ColorManager.gray_10 : ColorManager.gray_80
        underLineView.backgroundColor = isSelected ? ColorManager.common_0 : ColorManager.gray_98
    }
    
    private func layout(){
        [categoryLabel,underLineView]
            .forEach{
                contentView.addSubview($0)
            }
        
        categoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(2*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
