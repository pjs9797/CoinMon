import UIKit
import SnapKit

class SignupEmailEntryView: UIView {
    let enterEmailLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D2_24
        label.textColor = ColorManager.common_0
        return label
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_40
        return label
    }()
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.H2_20
        textField.textColor = ColorManager.common_0
        return textField
    }()
    let textFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_90
        return view
    }()
    let duplicateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.titleLabel?.font = FontManager.H4_16
        button.backgroundColor = ColorManager.gray_5
        button.layer.cornerRadius = 8*Constants.standardHeight
        return button
    }()
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B7_12
        label.textColor = ColorManager.red_50
        return label
    }()
    let emailDuplicateLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B7_12
        return label
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
        enterEmailLabel.text = LocalizationManager.shared.localizedString(forKey: "이메일을 입력해주세요")
        emailLabel.text = LocalizationManager.shared.localizedString(forKey: "이메일 아이디")
        emailTextField.placeholder = LocalizationManager.shared.localizedString(forKey: "사용하는 이메일을 입력")
        duplicateButton.setTitle(LocalizationManager.shared.localizedString(forKey: "중복확인"), for: .normal)
        emailErrorLabel.text = LocalizationManager.shared.localizedString(forKey: "올바른 이메일을 입력해주세요")
        nextButton.setTitle(LocalizationManager.shared.localizedString(forKey: "다음"), for: .normal)
    }
    
    private func layout() {
        [enterEmailLabel,emailLabel,emailTextField,textFieldLineView,duplicateButton,emailErrorLabel,emailDuplicateLabel,nextButton]
            .forEach{
                addSubview($0)
            }
        
        enterEmailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*Constants.standardHeight)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(enterEmailLabel.snp.bottom).offset(40*Constants.standardHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.width.equalTo(247*Constants.standardWidth)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(emailLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        textFieldLineView.snp.makeConstraints { make in
            make.width.equalTo(emailTextField.snp.width)
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(emailTextField.snp.bottom).offset(6*Constants.standardHeight)
        }
        
        duplicateButton.snp.makeConstraints { make in
            make.width.equalTo(80*Constants.standardWidth)
            make.height.equalTo(36*Constants.standardHeight)
            make.leading.equalTo(emailTextField.snp.trailing).offset(8*Constants.standardWidth)
            make.centerY.equalTo(emailTextField)
        }
        
        emailErrorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(textFieldLineView.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        emailDuplicateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(textFieldLineView.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*Constants.standardHeight)
        }
    }
}
