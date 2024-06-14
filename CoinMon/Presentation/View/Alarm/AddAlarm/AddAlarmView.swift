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
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5*Constants.standardWidth)
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
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5*Constants.standardWidth)
        return button
    }()
    let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.common_0
        return label
    }()
    let currentCoinPriceView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        view.layer.cornerRadius = 12*Constants.standardHeight
        return view
    }()
    let currentCoinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H5_15
        label.textColor = ColorManager.common_0
        label.textAlignment = .center
        return label
    }()
    let currentCoinPriceUnitLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H5_15
        label.textColor = ColorManager.common_0
        return label
    }()
    let setPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.common_0
        return label
    }()
    let setPriceView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        view.layer.cornerRadius = 12*Constants.standardHeight
        return view
    }()
    let setPriceTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.D7_15
        textField.textColor = ColorManager.common_0
        textField.textAlignment = .center
        return textField
    }()
    let setPriceUnitLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D7_15
        label.textColor = ColorManager.common_0
        return label
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
    let completeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12*Constants.standardHeight
        button.titleLabel?.font = FontManager.D6_16
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
        completeButton.setTitle(LocalizationManager.shared.localizedString(forKey: "완료"), for: .normal)
    }
    
    private func layout() {
        [marketButton,marketLabel,coinButton,coinLabel,currentCoinPriceView,currentPriceLabel,setPriceView,setPriceLabel,comparePriceButton,comparePriceLabel,cycleButton,cycleLabel,completeButton]
            .forEach{
                addSubview($0)
            }
        
        [currentCoinPriceUnitLabel,currentCoinPriceLabel]
            .forEach{
                currentCoinPriceView.addSubview($0)
            }
        
        [setPriceUnitLabel,setPriceTextField]
            .forEach{
                setPriceView.addSubview($0)
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
        
        currentCoinPriceView.snp.makeConstraints { make in
            make.width.equalTo(232*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(coinButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        currentCoinPriceUnitLabel.snp.makeConstraints { make in
            make.width.equalTo(60*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-5*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        currentCoinPriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-10*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        currentPriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalTo(currentCoinPriceLabel.snp.leading).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(currentCoinPriceLabel)
        }
        
        setPriceView.snp.makeConstraints { make in
            make.width.equalTo(232*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(currentCoinPriceView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        setPriceUnitLabel.snp.makeConstraints { make in
            make.width.equalTo(60*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-5*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        setPriceTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-10*Constants.standardWidth)
            make.centerY.equalToSuperview()
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
            make.top.equalTo(setPriceView.snp.bottom).offset(12*Constants.standardHeight)
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
        
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*Constants.standardHeight)
        }
    }
}
