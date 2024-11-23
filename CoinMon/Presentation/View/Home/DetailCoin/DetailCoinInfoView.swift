import UIKit
import SnapKit
import Kingfisher

class DetailCoinInfoView: UIView {
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let coinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D2_24
        label.textColor = ColorManager.common_0
        return label
    }()
    let comparePriceLabel: UILabel = {
        let label = UILabel()
        label.text = "어제대비 +1,580,475원(2.07%)"
        label.font = FontManager.B5_14
        label.textColor = ColorManager.red_50
        return label
    }()
    let alarmButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.D8_14
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.setTitleColor(ColorManager.gray_20, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8*ConstantsManager.standardHeight, left: 14*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, right: 14*ConstantsManager.standardWidth)
        let spacing: CGFloat = 4*ConstantsManager.standardWidth
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorManager.gray_96?.cgColor
        button.layer.cornerRadius = 8*ConstantsManager.standardHeight
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [coinImageView,coinTitleLabel,alarmButton,priceLabel,comparePriceLabel]
            .forEach{
                addSubview($0)
            }
        
        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalTo(coinImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(120*ConstantsManager.standardWidth)
            make.height.equalTo(38*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.height.equalTo(32*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(coinImageView.snp.bottom).offset(2*ConstantsManager.standardHeight)
        }
        
        comparePriceLabel.snp.makeConstraints { make in
            make.height.equalTo(22*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardHeight)
            make.top.equalTo(priceLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
    }
}
