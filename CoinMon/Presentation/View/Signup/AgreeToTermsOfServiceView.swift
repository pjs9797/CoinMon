import UIKit
import SnapKit

class AgreeToTermsOfServiceView: UIView {
    let agreeToTermsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D2_24
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let selectAllButton: UIButton = {
        let button = UIButton()
        let image = ImageManager.circle_Check
        button.setImage(image, for: .normal)
        return button
    }()
    let agreeAllLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H2_20
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let termsOfServiceCheckButton: UIButton = {
        let button = UIButton()
        return button
    }()
    let termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_14
        label.textColor = ColorManager.gray_20
        label.numberOfLines = 0
        return label
    }()
    let termsOfServiceDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.arrow_Chevron_Right, for: .normal)
        return button
    }()
    let privacyPolicyViewCheckButton: UIButton = {
        let button = UIButton()
        return button
    }()
    let privacyPolicyViewLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_14
        label.textColor = ColorManager.gray_20
        label.numberOfLines = 0
        return label
    }()
    let privacyPolicyViewDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.arrow_Chevron_Right, for: .normal)
        return button
    }()
    let marketingConsentViewCheckButton: UIButton = {
        let button = UIButton()
        return button
    }()
    let marketingConsentViewLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_14
        label.textColor = ColorManager.gray_20
        label.numberOfLines = 0
        return label
    }()
    let marketingConsentViewDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.arrow_Chevron_Right, for: .normal)
        return button
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.layer.cornerRadius = 12*Constants.standardHeight
        button.titleLabel?.font = FontManager.D6_16
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLocalizedText()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLocalizedText(){
        agreeToTermsOfServiceLabel.text = LocalizationManager.shared.localizedString(forKey: "약관 동의")
        agreeAllLabel.text = LocalizationManager.shared.localizedString(forKey: "약관에 모두 동의해요")
        termsOfServiceLabel.text = LocalizationManager.shared.localizedString(forKey: "[필수] 서비스 이용약관")
        privacyPolicyViewLabel.text = LocalizationManager.shared.localizedString(forKey: "[필수] 개인정보 수집∙이용 동의")
        marketingConsentViewLabel.text = LocalizationManager.shared.localizedString(forKey: "[선택] 마케팅 정보 수신 동의")
        nextButton.setTitle(LocalizationManager.shared.localizedString(forKey: "다음"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        agreeToTermsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalToSuperview().offset(40*Constants.standardHeight)
        }
        
        selectAllButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(agreeToTermsOfServiceLabel.snp.bottom).offset(26*Constants.standardHeight)
        }
        
        agreeAllLabel.snp.makeConstraints { make in
            make.leading.equalTo(selectAllButton.snp.trailing).offset(8*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(selectAllButton)
        }
        
        termsOfServiceCheckButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(agreeAllLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        termsOfServiceDetailButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(termsOfServiceCheckButton)
        }
        
        termsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalTo(agreeAllLabel.snp.leading)
            make.trailing.equalTo(termsOfServiceDetailButton.snp.leading).offset(-8*Constants.standardWidth)
            make.top.equalTo(agreeAllLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        privacyPolicyViewLabel.snp.makeConstraints { make in
            make.leading.equalTo(termsOfServiceLabel.snp.leading)
            make.trailing.equalTo(termsOfServiceLabel.snp.trailing)
            make.top.equalTo(termsOfServiceLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        privacyPolicyViewCheckButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.centerY.equalTo(privacyPolicyViewLabel)
        }
        
        privacyPolicyViewDetailButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(privacyPolicyViewLabel)
        }
        
        marketingConsentViewLabel.snp.makeConstraints { make in
            make.leading.equalTo(privacyPolicyViewLabel.snp.leading)
            make.trailing.equalTo(privacyPolicyViewLabel.snp.trailing)
            make.top.equalTo(privacyPolicyViewLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        marketingConsentViewCheckButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.centerY.equalTo(marketingConsentViewLabel)
        }
        
        marketingConsentViewDetailButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(marketingConsentViewLabel)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*Constants.standardHeight)
        }
    }
    
    private func layout() {
        [agreeToTermsOfServiceLabel,selectAllButton,agreeAllLabel,termsOfServiceCheckButton,termsOfServiceDetailButton,termsOfServiceLabel,privacyPolicyViewLabel,privacyPolicyViewCheckButton,privacyPolicyViewDetailButton,marketingConsentViewLabel,marketingConsentViewCheckButton,marketingConsentViewDetailButton,nextButton]
            .forEach{
                addSubview($0)
            }
    }
}
