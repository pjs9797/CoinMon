import UIKit
import SnapKit

class SecondInfoView: UIView {
    let marketPriceLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "시세2")
        label.textColor = ColorManager.common_0
        label.font = FontManager.D5_18
        return label
    }()
    let highPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "전일 고가")
        label.textColor = ColorManager.common_0
        label.font = FontManager.T4_15
        return label
    }()
    let lowPriceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "전일 저가")
        label.textColor = ColorManager.common_0
        label.font = FontManager.T4_15
        return label
    }()
    let highPriceLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "미제공")
        label.textColor = ColorManager.common_0
        label.font = FontManager.H5_15
        return label
    }()
    let lowPriceLabel: UILabel = {
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
        [marketPriceLabel,highPriceTitleLabel,highPriceLabel,lowPriceTitleLabel,lowPriceLabel]
            .forEach{
                addSubview($0)
            }
        
        marketPriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(23*ConstantsManager.standardHeight)
        }
        
        highPriceTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(marketPriceLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        highPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(highPriceTitleLabel)
        }
        
        lowPriceTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(highPriceTitleLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
        
        lowPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(lowPriceTitleLabel)
        }
    }
}
