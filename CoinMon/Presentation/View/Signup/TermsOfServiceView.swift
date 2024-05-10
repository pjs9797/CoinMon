import UIKit
import SnapKit

class TermsOfServiceView: UIView {
    let termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H2_24
        label.textColor = ColorManager.color_neutral_5
        label.numberOfLines = 0
        return label
    }()
    let selectAllButton: UIButton = {
        let button = UIButton()
        let image = ImageManager.Circle_Check?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        return button
    }()
    let agreeAllLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H4_20
        label.textColor = ColorManager.color_neutral_10
        label.numberOfLines = 0
        return label
    }()
    let firstCheckButton: UIButton = {
        let button = UIButton()
        let image = ImageManager.Check?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        return button
    }()
    let firstTermsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T4_14
        label.textColor = ColorManager.color_neutral_15
        label.numberOfLines = 0
        return label
    }()
    let firstTermsOfServiceDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.Arrow_Chevron_Right, for: .normal)
        return button
    }()
    let secondCheckButton: UIButton = {
        let button = UIButton()
        let image = ImageManager.Check?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        return button
    }()
    let secondTermsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T4_14
        label.textColor = ColorManager.color_neutral_15
        label.numberOfLines = 0
        return label
    }()
    let secondTermsOfServiceDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.Arrow_Chevron_Right, for: .normal)
        return button
    }()
    let thirdCheckButton: UIButton = {
        let button = UIButton()
        let image = ImageManager.Check?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        return button
    }()
    let thirdTermsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T4_14
        label.textColor = ColorManager.color_neutral_15
        label.numberOfLines = 0
        return label
    }()
    let thirdTermsOfServiceDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.Arrow_Chevron_Right, for: .normal)
        return button
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12*Constants.standardHeight
        button.titleLabel?.font = FontManager.H6_16
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
        termsOfServiceLabel.text = NSLocalizedString("약관 동의", comment: "")
        agreeAllLabel.text = NSLocalizedString("약관에 모두 동의해요", comment: "")
        firstTermsOfServiceLabel.text = NSLocalizedString("[필수] 서비스 이용약관", comment: "")
        secondTermsOfServiceLabel.text = NSLocalizedString("[필수] 개인정보 수집∙이용 동의", comment: "")
        thirdTermsOfServiceLabel.text = NSLocalizedString("[선택] 마케팅 정보 수신 동의", comment: "")
        nextButton.setTitle(NSLocalizedString("다음", comment: ""), for: .normal)
    }
    
    private func layout() {
        [termsOfServiceLabel,selectAllButton,agreeAllLabel,firstCheckButton,firstTermsOfServiceDetailButton,firstTermsOfServiceLabel,secondTermsOfServiceLabel,secondCheckButton,secondTermsOfServiceDetailButton,thirdTermsOfServiceLabel,thirdCheckButton,thirdTermsOfServiceDetailButton,nextButton]
            .forEach{
                addSubview($0)
            }
        
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
            make.top.equalTo(selectAllButton.snp.bottom).offset(26*Constants.standardHeight)
        }
        
        firstTermsOfServiceDetailButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalTo(firstCheckButton)
        }
        
        firstTermsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstCheckButton.snp.trailing).offset(8*Constants.standardWidth)
            make.trailing.equalTo(firstTermsOfServiceDetailButton.snp.leading).offset(-8*Constants.standardWidth)
            make.centerY.equalTo(firstCheckButton)
        }
        
        secondTermsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstTermsOfServiceLabel.snp.leading)
            make.trailing.equalTo(firstTermsOfServiceLabel.snp.trailing)
            make.top.equalTo(firstTermsOfServiceLabel.snp.bottom).offset(14*Constants.standardHeight)
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
            make.top.equalTo(secondTermsOfServiceLabel.snp.bottom).offset(14*Constants.standardHeight)
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
}
