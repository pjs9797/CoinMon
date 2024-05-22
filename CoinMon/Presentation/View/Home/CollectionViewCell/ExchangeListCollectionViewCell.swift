import UIKit
import SnapKit

class ExchangeListCollectionViewCell: UICollectionViewCell {
    let exchangeImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let exchangeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.gray_60
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8*Constants.standardHeight
        self.backgroundColor = ColorManager.gray_99
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            exchangeLabel.textColor = isSelected ? ColorManager.common_0 : ColorManager.gray_60
            self.backgroundColor = isSelected ? ColorManager.common_100 : ColorManager.gray_99
        }
    }
    
    private func layout(){
        [exchangeImageView,exchangeLabel]
            .forEach{
                contentView.addSubview($0)
            }
        
        exchangeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*Constants.standardHeight)
            make.leading.equalToSuperview().offset(8*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        exchangeLabel.snp.makeConstraints { make in
            make.leading.equalTo(exchangeImageView.snp.trailing).offset(2*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
}
