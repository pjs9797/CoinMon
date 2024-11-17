import UIKit
import SnapKit

class SettingView: UIView {
    let trialUserViewTapGesture = UITapGestureRecognizer()
    let subscriptionUserViewTapGesture = UITapGestureRecognizer()
    let settingLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D3_22
        label.textColor = ColorManager.common_0
        return label
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage1")
        imageView.layer.cornerRadius = 40*ConstantsManager.standardHeight
        return imageView
    }()
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.arrow_Right, for: .normal)
        return button
    }()
    let normalUserView = NormalUserView()
    let trialUserView = TrialUserView()
    let subscriptionUserView = SubscriptionUserView()
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
            .foregroundColor: ColorManager.gray_70!
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.H4_16,
            .foregroundColor: ColorManager.common_0!,
            .backgroundColor: ColorManager.common_100!
        ]
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        segmentedControl.selectedSegmentIndex = LocalizationManager.shared.language == "ko" ? 0 : 1
        segmentedControl.layer.cornerRadius = 8*ConstantsManager.standardHeight
        return segmentedControl
    }()
    let alarmSettingButton: UIButton = {
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
    let privacyPolicyButton: UIButton = {
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
    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T3_16
        label.textColor = ColorManager.gray_50
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trialUserView.addGestureRecognizer(trialUserViewTapGesture)
        subscriptionUserView.addGestureRecognizer(subscriptionUserViewTapGesture)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        settingLabel.text = LocalizationManager.shared.localizedString(forKey: "설정")
        languageLabel.text = LocalizationManager.shared.localizedString(forKey: "언어")
        alarmSettingButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알림 설정"), for: .normal)
        inquiryButton.setTitle(LocalizationManager.shared.localizedString(forKey: "문의"), for: .normal)
        termsOfServiceButton.setTitle(LocalizationManager.shared.localizedString(forKey: "이용약관"), for: .normal)
        privacyPolicyButton.setTitle(LocalizationManager.shared.localizedString(forKey: "개인정보 처리방침"), for: .normal)
        versionLabel.text = LocalizationManager.shared.localizedString(forKey: "현재 버전")
        normalUserView.setLocalizedText()
        trialUserView.setLocalizedText()
        subscriptionUserView.setLocalizedText()
    }
    
    private func layout() {
        [settingLabel,profileImageView,nicknameLabel,rightButton,normalUserView,trialUserView,subscriptionUserView,languageLabel,languageSegmentedControl,alarmSettingButton,inquiryButton,termsOfServiceButton,privacyPolicyButton,versionLabel]
            .forEach{
                addSubview($0)
            }
        
        settingLabel.snp.makeConstraints { make in
            make.height.equalTo(44*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(settingLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(profileImageView)
        }
        
        rightButton.snp.makeConstraints { make in
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(profileImageView)
        }
        
        normalUserView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalTo(profileImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        trialUserView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalTo(profileImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        subscriptionUserView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalTo(profileImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.width.equalTo(100*ConstantsManager.standardWidth)
            make.height.equalTo(56*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(profileImageView.snp.bottom).offset(172*ConstantsManager.standardHeight)
        }
        
        languageSegmentedControl.snp.makeConstraints { make in
            make.width.equalTo(100*ConstantsManager.standardWidth)
            make.height.equalTo(40*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(languageLabel)
        }
        
        alarmSettingButton.snp.makeConstraints { make in
            make.height.equalTo(56*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(languageLabel.snp.bottom)
        }
        
        inquiryButton.snp.makeConstraints { make in
            make.height.equalTo(56*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(alarmSettingButton.snp.bottom)
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.height.equalTo(56*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(inquiryButton.snp.bottom)
        }
        
        termsOfServiceButton.snp.makeConstraints { make in
            make.height.equalTo(56*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(privacyPolicyButton.snp.bottom)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.width.equalTo(200*ConstantsManager.standardWidth)
            make.height.equalTo(56*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(termsOfServiceButton.snp.bottom)
        }
    }
    
    func setUserView(status: UserSubscriptionStatus) {
        if status.status == .normal {
            normalUserView.isHidden = false
            trialUserView.isHidden = true
            subscriptionUserView.isHidden = true
            
            languageLabel.snp.remakeConstraints { make in
                make.width.equalTo(100*ConstantsManager.standardWidth)
                make.height.equalTo(56*ConstantsManager.standardHeight)
                make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
                make.top.equalTo(profileImageView.snp.bottom).offset(172*ConstantsManager.standardHeight)
            }
            
            if status.useTrialYN == "Y" {
                normalUserView.trialButton.configuration?.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "14일 무료 체험하기"), attributes: .init([.font: FontManager.H4_16]))
            }
            else {
                normalUserView.trialButton.configuration?.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "프리미엄 구독하기"), attributes: .init([.font: FontManager.H4_16]))
            }
        }
        else if status.status == .trial {
            normalUserView.isHidden = true
            trialUserView.isHidden = false
            subscriptionUserView.isHidden = true
            
            languageLabel.snp.remakeConstraints { make in
                make.width.equalTo(100*ConstantsManager.standardWidth)
                make.height.equalTo(56*ConstantsManager.standardHeight)
                make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
                make.top.equalTo(profileImageView.snp.bottom).offset(88*ConstantsManager.standardHeight)
            }
        }
        else if status.status == .subscription{
            normalUserView.isHidden = true
            trialUserView.isHidden = true
            subscriptionUserView.isHidden = false
            
            languageLabel.snp.remakeConstraints { make in
                make.width.equalTo(100*ConstantsManager.standardWidth)
                make.height.equalTo(56*ConstantsManager.standardHeight)
                make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
                make.top.equalTo(profileImageView.snp.bottom).offset(88*ConstantsManager.standardHeight)
            }
        }
    }
}
