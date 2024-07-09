import UIKit
import SnapKit

class SettingView: UIView {
    let settingLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D3_22
        label.textColor = ColorManager.common_0
        return label
    }()
    let languageLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H4_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let languageSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KR", "EN"])
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.H4_16,
            .foregroundColor: ColorManager.gray_70
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.H4_16,
            .foregroundColor: UIColor.black,
            .backgroundColor: UIColor.white
        ]
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.selectedSegmentIndex = LocalizationManager.shared.language == "ko" ? 0 : 1
        segmentedControl.layer.cornerRadius = 8*Constants.standardHeight
        return segmentedControl
    }()
    let alarmSettingButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.H4_16
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    let myAccountButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.H4_16
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    let inquiryButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.H4_16
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    let termsOfServiceButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.H4_16
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FontManager.H4_16
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T3_16
        label.textColor = ColorManager.gray_50
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [settingLabel,languageLabel,languageSegmentedControl,alarmSettingButton,myAccountButton,inquiryButton,termsOfServiceButton,privacyPolicyButton,versionLabel]
            .forEach{
                addSubview($0)
            }
        
        settingLabel.snp.makeConstraints { make in
            make.height.equalTo(42*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5*Constants.standardHeight)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.width.equalTo(100*Constants.standardWidth)
            make.height.equalTo(56*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(settingLabel.snp.bottom).offset(37*Constants.standardHeight)
        }
        
        languageSegmentedControl.snp.makeConstraints { make in
            make.width.equalTo(100*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(languageLabel)
        }
        
        alarmSettingButton.snp.makeConstraints { make in
            make.height.equalTo(56*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(languageLabel.snp.bottom)
        }
        
        myAccountButton.snp.makeConstraints { make in
            make.height.equalTo(56*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(alarmSettingButton.snp.bottom)
        }
        
        inquiryButton.snp.makeConstraints { make in
            make.height.equalTo(56*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(myAccountButton.snp.bottom)
        }
        
        termsOfServiceButton.snp.makeConstraints { make in
            make.height.equalTo(56*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(inquiryButton.snp.bottom)
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.height.equalTo(56*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(termsOfServiceButton.snp.bottom)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.width.equalTo(200*Constants.standardWidth)
            make.height.equalTo(56*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(privacyPolicyButton.snp.bottom)
        }
    }
}
