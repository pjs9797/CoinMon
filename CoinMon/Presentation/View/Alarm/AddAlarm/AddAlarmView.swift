import UIKit
import SnapKit

class AddAlarmView: UIView {
    let marketLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.common_0
        return label
    }()
    let marketButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.D7_15
        button.backgroundColor = ColorManager.gray_99
        button.layer.cornerRadius = 12*Constants.standardHeight
        return button
    }()
    let coinLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.common_0
        return label
    }()
    let coinButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.D7_15
        button.backgroundColor = ColorManager.gray_99
        button.layer.cornerRadius = 12*Constants.standardHeight
        return button
    }()
    let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.common_0
        return label
    }()
    let currentCoinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H5_15
        label.textColor = ColorManager.common_0
        label.backgroundColor = ColorManager.gray_99
        label.layer.cornerRadius = 12*Constants.standardHeight
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    let setPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.common_0
        return label
    }()
    let setPriceTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.D7_15
        textField.textColor = ColorManager.common_0
        textField.backgroundColor = ColorManager.gray_99
        textField.layer.cornerRadius = 12*Constants.standardHeight
        textField.clipsToBounds = true
        textField.textAlignment = .center
        return textField
    }()
    let comparePriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let comparePriceButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.D7_15
        button.backgroundColor = ColorManager.gray_99
        button.layer.cornerRadius = 12*Constants.standardHeight
        return button
    }()
    let cycleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.common_0
        return label
    }()
    let cycleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.D7_15
        button.backgroundColor = ColorManager.gray_99
        button.layer.cornerRadius = 12*Constants.standardHeight
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        marketLabel.text = LocalizationManager.shared.localizedString(forKey: "거래소")
        coinLabel.text = LocalizationManager.shared.localizedString(forKey: "코인")
        currentPriceLabel.text = LocalizationManager.shared.localizedString(forKey: "현재가")
        setPriceLabel.text = LocalizationManager.shared.localizedString(forKey: "설정가")
        comparePriceLabel.text = LocalizationManager.shared.localizedString(forKey: "현재가 대비")
        cycleLabel.text = LocalizationManager.shared.localizedString(forKey: "주기")
    }
    
    private func layout() {
        [marketButton,marketLabel,coinButton,coinLabel,currentCoinPriceLabel,currentPriceLabel,setPriceTextField,setPriceLabel,comparePriceButton,comparePriceLabel,cycleButton,cycleLabel]
            .forEach{
                addSubview($0)
            }
        
        marketButton.snp.makeConstraints { make in
            make.width.equalTo(232*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(22*Constants.standardHeight)
        }
        
        marketLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalTo(marketButton.snp.leading).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(marketButton)
        }
        
        coinButton.snp.makeConstraints { make in
            make.width.equalTo(232*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(marketButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        coinLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalTo(coinButton.snp.leading).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(coinButton)
        }
        
        currentCoinPriceLabel.snp.makeConstraints { make in
            make.width.equalTo(232*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(coinButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        currentPriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalTo(currentCoinPriceLabel.snp.leading).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(currentCoinPriceLabel)
        }
        
        setPriceTextField.snp.makeConstraints { make in
            make.width.equalTo(232*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(currentCoinPriceLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        setPriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalTo(setPriceTextField.snp.leading).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(setPriceTextField)
        }
        
        comparePriceButton.snp.makeConstraints { make in
            make.width.equalTo(232*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(setPriceTextField.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        comparePriceLabel.snp.makeConstraints { make in
            make.height.equalTo(comparePriceButton.snp.height)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalTo(comparePriceButton.snp.leading).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(comparePriceButton)
        }
        
        cycleButton.snp.makeConstraints { make in
            make.width.equalTo(232*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(comparePriceButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        cycleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalTo(cycleButton.snp.leading).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(cycleButton)
        }
    }
}
