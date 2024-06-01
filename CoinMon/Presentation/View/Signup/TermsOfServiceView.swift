import UIKit
import SnapKit

class TermsOfServiceView: UIView {
    let termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D2_24
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let selectAllButton: UIButton = {
        let button = UIButton()
        let image = ImageManager.circle_Check?.withRenderingMode(.alwaysTemplate)
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
    let firstCheckButton: UIButton = {
        let button = UIButton()
        return button
    }()
    let firstTermsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_14
        label.textColor = ColorManager.gray_20
        label.numberOfLines = 0
        return label
    }()
    let firstTermsOfServiceDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.arrow_Chevron_Right, for: .normal)
        return button
    }()
    let secondCheckButton: UIButton = {
        let button = UIButton()
        return button
    }()
    let secondTermsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_14
        label.textColor = ColorManager.gray_20
        label.numberOfLines = 0
        return label
    }()
    let secondTermsOfServiceDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.arrow_Chevron_Right, for: .normal)
        return button
    }()
    let thirdCheckButton: UIButton = {
        let button = UIButton()
        return button
    }()
    let thirdTermsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_14
        label.textColor = ColorManager.gray_20
        label.numberOfLines = 0
        return label
    }()
    let thirdTermsOfServiceDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.arrow_Chevron_Right, for: .normal)
        return button
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
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
        termsOfServiceLabel.text = LocalizationManager.shared.localizedString(forKey: "약관 동의")
        agreeAllLabel.text = LocalizationManager.shared.localizedString(forKey: "약관에 모두 동의해요")
        firstTermsOfServiceLabel.text = LocalizationManager.shared.localizedString(forKey: "[필수] 서비스 이용약관")
        secondTermsOfServiceLabel.text = LocalizationManager.shared.localizedString(forKey: "[필수] 개인정보 수집∙이용 동의")
        thirdTermsOfServiceLabel.text = LocalizationManager.shared.localizedString(forKey: "[선택] 마케팅 정보 수신 동의")
        nextButton.setTitle(LocalizationManager.shared.localizedString(forKey: "다음"), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        termsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalToSuperview().offset(40*Constants.standardHeight)
        }
        
        selectAllButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(termsOfServiceLabel.snp.bottom).offset(26*Constants.standardHeight)
        }
        
        agreeAllLabel.snp.makeConstraints { make in
            make.leading.equalTo(selectAllButton.snp.trailing).offset(8*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(selectAllButton)
        }
        
        firstCheckButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(agreeAllLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        firstTermsOfServiceDetailButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(firstCheckButton)
        }
        
        firstTermsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalTo(agreeAllLabel.snp.leading)
            make.trailing.equalTo(firstTermsOfServiceDetailButton.snp.leading).offset(-8*Constants.standardWidth)
            make.top.equalTo(agreeAllLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        secondTermsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstTermsOfServiceLabel.snp.leading)
            make.trailing.equalTo(firstTermsOfServiceLabel.snp.trailing)
            make.top.equalTo(firstTermsOfServiceLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        secondCheckButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.centerY.equalTo(secondTermsOfServiceLabel)
        }
        
        secondTermsOfServiceDetailButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(secondTermsOfServiceLabel)
        }
        
        thirdTermsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalTo(secondTermsOfServiceLabel.snp.leading)
            make.trailing.equalTo(secondTermsOfServiceLabel.snp.trailing)
            make.top.equalTo(secondTermsOfServiceLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        thirdCheckButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.centerY.equalTo(thirdTermsOfServiceLabel)
        }
        
        thirdTermsOfServiceDetailButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(thirdTermsOfServiceLabel)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*Constants.standardHeight)
        }
    }
    
    private func layout() {
        [termsOfServiceLabel,selectAllButton,agreeAllLabel,firstCheckButton,firstTermsOfServiceDetailButton,firstTermsOfServiceLabel,secondTermsOfServiceLabel,secondCheckButton,secondTermsOfServiceDetailButton,thirdTermsOfServiceLabel,thirdCheckButton,thirdTermsOfServiceDetailButton,nextButton]
            .forEach{
                addSubview($0)
            }
    }
}
