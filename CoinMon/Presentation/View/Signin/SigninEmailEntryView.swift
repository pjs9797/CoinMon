import UIKit
import SnapKit

class SigninEmailEntryView: UIView {
    let enterEmailLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: LocalizationManager.shared.localizedString(forKey: "이메일을 입력해주세요"), fontStyle: FontManagerA.D2_24, textColor: ColorManager.common_0)
        return label
    }()
    let emailLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: LocalizationManager.shared.localizedString(forKey: "이메일 아이디"), fontStyle: FontManagerA.T6_13, textColor: ColorManager.gray_40)
        return label
    }()
    let emailTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.setStyle(placeholder: LocalizationManager.shared.localizedString(forKey: "사용하는 이메일을 입력"), style: FontManagerA.H2_20, textColor: ColorManager.common_0)
        return textField
    }()
    let clearButton: BaseButton = {
        let button = BaseButton()
        button.setImage(image: ImageManager.iconClear)
        return button
    }()
    let textFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_90
        return view
    }()
    let emailErrorLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: LocalizationManager.shared.localizedString(forKey: "올바른 이메일을 입력해주세요"), fontStyle: FontManagerA.B7_12, textColor: ColorManager.red_50)
        return label
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "다음"), for: .normal)
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.titleLabel?.font = FontManager.D6_16
        button.accessibilityIdentifier = "signin_nextButton"
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAccessibilityIdentifier()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAccessibilityIdentifier() {
        enterEmailLabel.accessibilityIdentifier = "signin_enterEmailLabel"
        emailLabel.accessibilityIdentifier = "signin_emailLabel"
        emailTextField.accessibilityIdentifier = "signin_emailTextField"
        clearButton.accessibilityIdentifier = "signin_clearButton"
        emailErrorLabel.accessibilityIdentifier = "signin_emailErrorLabel"
    }
    
    private func layout() {
        [enterEmailLabel,emailLabel,emailTextField,clearButton,textFieldLineView,emailErrorLabel,nextButton]
            .forEach{
                addSubview($0)
            }
        
        enterEmailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*ConstantsManager.standardHeight)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(enterEmailLabel.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(emailLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalTo(emailTextField)
            make.centerY.equalTo(emailTextField)
        }
        
        textFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(emailTextField.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        emailErrorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(textFieldLineView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
    }
}
