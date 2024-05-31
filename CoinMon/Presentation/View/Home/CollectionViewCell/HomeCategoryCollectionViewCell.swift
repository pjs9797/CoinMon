import UIKit
import SnapKit

class HomeCategoryCollectionViewCell: UICollectionViewCell {
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D3_22
        label.textAlignment = .center
        return label
    }()
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_10
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
        underLineView.isHidden = isSelected ? false : true
    }
    
    private func layout(){
        [categoryLabel,underLineView]
            .forEach{
                contentView.addSubview($0)
            }
        
        categoryLabel.snp.makeConstraints { make in
            make.height.equalTo(30*Constants.standardHeight)
            make.leading.equalToSuperview().offset(6*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-6*Constants.standardWidth)
            make.top.equalToSuperview().offset(4*Constants.standardHeight)
        }
        
        underLineView.snp.makeConstraints { make in
            make.width.equalTo(categoryLabel.snp.width)
            make.height.equalTo(2*Constants.standardHeight)
            make.centerX.equalTo(categoryLabel)
            make.top.equalTo(categoryLabel.snp.bottom).offset(2*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-4*Constants.standardHeight)
        }
    }
}
