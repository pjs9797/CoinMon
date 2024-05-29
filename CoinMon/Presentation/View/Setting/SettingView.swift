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
            .foregroundColor: UIColor.black
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
    let alertSettingButton: UIButton = {
        let button = UIButton()
        return button
    }()
    let myAccountButton: UIButton = {
        let button = UIButton()
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
        [settingLabel,languageLabel,languageSegmentedControl]
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
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(settingLabel.snp.bottom).offset(37*Constants.standardHeight)
        }
        
        languageSegmentedControl.snp.makeConstraints { make in
            make.width.equalTo(100*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(languageLabel)
        }
    }
}
