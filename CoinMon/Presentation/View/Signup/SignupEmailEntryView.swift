import UIKit
import SnapKit

class SignupEmailEntryView: UIView {
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
    let textFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_90
        return view
    }()
    let duplicateButton: BaseButton = {
        let button = BaseButton()
        button.setConfiguration(title: LocalizationManager.shared.localizedString(forKey: "중복확인"), fontStyle: FontManagerA.H4_16, foregroundColor: ColorManager.common_100, backgroundColor: ColorManager.gray_90)
        button.layer.cornerRadius = 8*ConstantsManager.standardHeight
        button.clipsToBounds = true
        return button
    }()
    let emailErrorLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: LocalizationManager.shared.localizedString(forKey: "올바른 이메일을 입력해주세요"), fontStyle: FontManagerA.B7_12, textColor: ColorManager.red_50)
        return label
    }()
    let emailDuplicateLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: "", fontStyle: FontManagerA.B7_12, textColor: ColorManager.common_0)
        return label
    }()
    let nextButton: BottomButtonA = {
        let button = BottomButtonA()
        button.updateTitle(LocalizationManager.shared.localizedString(forKey: "다음"))
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
        [enterEmailLabel,emailLabel,emailTextField,textFieldLineView,duplicateButton,emailErrorLabel,emailDuplicateLabel,nextButton]
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
            make.width.equalTo(247*ConstantsManager.standardWidth)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(emailLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        textFieldLineView.snp.makeConstraints { make in
            make.width.equalTo(emailTextField.snp.width)
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(emailTextField.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        duplicateButton.snp.makeConstraints { make in
            make.width.equalTo(80*ConstantsManager.standardWidth)
            make.height.equalTo(36*ConstantsManager.standardHeight)
            make.leading.equalTo(emailTextField.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(emailTextField)
        }
        
        emailErrorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(textFieldLineView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        emailDuplicateLabel.snp.makeConstraints { make in
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
