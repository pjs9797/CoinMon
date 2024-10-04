import UIKit
import SnapKit

class PriceChangeCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T7_12_read
        label.textColor = ColorManager.gray_22
        label.textAlignment = .center
        return label
    }()
    let percentView = UIView()
    let imageView = UIImageView()
    let percentLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T7_12
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [imageView,percentLabel]
            .forEach{
                percentView.addSubview($0)
            }
        [titleLabel,percentView]
            .forEach{
                contentView.addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(8*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-8*ConstantsManager.standardWidth)
        }
        
        percentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview().inset(8*ConstantsManager.standardWidth)
            make.bottom.equalToSuperview().offset(-4*ConstantsManager.standardWidth)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(12*ConstantsManager.standardHeight)
        }
        
        percentLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(2*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(imageView)
        }
    }
    
    func configure(with data: PriceChange){
        titleLabel.text = data.title
        if data.priceChange >= 0 {
            if data.priceChange == 1000000000 {
                percentLabel.text = ""
                percentLabel.textColor = ColorManager.common_0
            }
            else {
                imageView.image = ImageManager.change_up
                percentLabel.text = "\(data.priceChange)%"
                percentLabel.textColor = ColorManager.red_50
            }
        }
        else {
            imageView.image = ImageManager.change_down
            percentLabel.text = "\(data.priceChange)%"
            percentLabel.textColor = ColorManager.blue_50
        }
    }
}
