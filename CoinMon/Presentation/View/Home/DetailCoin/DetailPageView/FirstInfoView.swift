import UIKit
import SnapKit
import Kingfisher

class FirstInfoView: UIView {
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
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "정보")
        label.textColor = ColorManager.common_0
        label.font = FontManager.D5_18
        return label
    }()
    let marketCapTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "시가 총액")
        label.textColor = ColorManager.common_0
        label.font = FontManager.T4_15
        return label
    }()
    let totalSupplyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "총 발행 수량")
        label.textColor = ColorManager.common_0
        label.font = FontManager.T4_15
        return label
    }()
    let marketCapLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "미제공")
        label.textColor = ColorManager.common_0
        label.font = FontManager.H5_15
        return label
    }()
    let totalSupplyLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "미제공")
        label.textColor = ColorManager.common_0
        label.font = FontManager.H5_15
        return label
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
        [coinImageView,coinTitleLabel,infoLabel,marketCapTitleLabel,marketCapLabel,totalSupplyTitleLabel,totalSupplyLabel]
            .forEach{
                addSubview($0)
            }
        
        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(23*ConstantsManager.standardHeight)
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinImageView.snp.trailing).offset(12*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(coinImageView.snp.bottom).offset(31*ConstantsManager.standardHeight)
        }
        
        marketCapTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(infoLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        marketCapLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(marketCapTitleLabel)
        }
        
        totalSupplyTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(marketCapTitleLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
        
        totalSupplyLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(totalSupplyTitleLabel)
        }
    }
}
