import UIKit
import SnapKit

class VerificationNumberView: UIView {
    let enterVerificationNumberLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: LocalizationManager.shared.localizedString(forKey: "인증번호를 입력해주세요"), fontStyle: FontManagerA.D2_24, textColor: ColorManager.common_0)
        label.numberOfLines = 0
        return label
    }()
    let sentVerificationNumberLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: LocalizationManager.shared.localizedString(forKey: "에 인증번호를 보냈어요", arguments: UserCredentialsManager.shared.email), fontStyle: FontManagerA.B5_14, textColor: ColorManager.gray_15)
        label.numberOfLines = 0
        return label
    }()
    let verificationNumberLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: LocalizationManager.shared.localizedString(forKey: "인증번호"), fontStyle: FontManagerA.T6_13, textColor: ColorManager.gray_40)
        return label
    }()
    let verificationNumberTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.setStyle(placeholder: LocalizationManager.shared.localizedString(forKey: "6자리 인증번호 입력"), style: FontManagerA.H2_20, textColor: ColorManager.common_0)
        textField.keyboardType = .numberPad
        return textField
    }()
    let timerLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: "", fontStyle: FontManagerA.T6_13, textColor: ColorManager.orange_50)
        return label
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
    let nextButton: BottomButtonA = {
        let button = BottomButtonA()
        button.updateTitle(LocalizationManager.shared.localizedString(forKey: "다음"))
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [enterVerificationNumberLabel,sentVerificationNumberLabel,verificationNumberLabel,verificationNumberTextField,timerLabel,clearButton,textFieldLineView,nextButton]
            .forEach{
                addSubview($0)
            }
        
        enterVerificationNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*ConstantsManager.standardHeight)
        }
        
        sentVerificationNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(enterVerificationNumberLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        verificationNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(sentVerificationNumberLabel.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        verificationNumberTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(verificationNumberLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(verificationNumberTextField)
            make.centerY.equalTo(verificationNumberTextField)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalTo(timerLabel.snp.leading).offset(-5*ConstantsManager.standardWidth)
            make.centerY.equalTo(verificationNumberTextField)
        }
        
        textFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(verificationNumberTextField.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
    }
}
