import UIKit
import SnapKit

class VerificationNumberView: UIView {
    let verificationType: VerificationType
    let enterVerificationNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D2_24
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let sentVerificationNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B5_14
        label.textColor = ColorManager.gray_15
        label.numberOfLines = 0
        return label
    }()
    let verificationNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_40
        return label
    }()
    let verificationNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.H2_20
        textField.textColor = ColorManager.common_0
        textField.keyboardType = .numberPad
        return textField
    }()
    let timerLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T6_13
        label.textColor = ColorManager.orange_50
        return label
    }()
    let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.iconClear, for: .normal)
        return button
    }()
    let textFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_90
        return view
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.layer.cornerRadius = 12*Constants.standardHeight
        button.titleLabel?.font = FontManager.D6_16
        return button
    }()
    
    init(verificationType: VerificationType) {
        self.verificationType = verificationType
        super.init(frame: .zero)
        setLocalizedText()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLocalizedText(){
        enterVerificationNumberLabel.text = LocalizationManager.shared.localizedString(forKey: "인증번호를 입력해주세요")
        switch verificationType {
        case .email:
            sentVerificationNumberLabel.text = LocalizationManager.shared.localizedString(forKey: "에 인증번호를 보냈어요", arguments: UserCredentialsManager.shared.email)
        case .phone:
            sentVerificationNumberLabel.text = LocalizationManager.shared.localizedString(forKey: "에 인증번호를 보냈어요", arguments: UserCredentialsManager.shared.phoneNumber)
        }
        verificationNumberLabel.text = LocalizationManager.shared.localizedString(forKey: "인증번호")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.gray_70 ?? UIColor.gray
        ]
        verificationNumberTextField.attributedPlaceholder = NSAttributedString(string: LocalizationManager.shared.localizedString(forKey: "6자리 인증번호 입력"), attributes: attributes)
        nextButton.setTitle(LocalizationManager.shared.localizedString(forKey: "다음"), for: .normal)
    }
    
    private func layout() {
        [enterVerificationNumberLabel,sentVerificationNumberLabel,verificationNumberLabel,verificationNumberTextField,timerLabel,clearButton,textFieldLineView,nextButton]
            .forEach{
                addSubview($0)
            }
        
        enterVerificationNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*Constants.standardHeight)
        }
        
        sentVerificationNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(enterVerificationNumberLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        verificationNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(sentVerificationNumberLabel.snp.bottom).offset(40*Constants.standardHeight)
        }
        
        verificationNumberTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(verificationNumberLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.trailing.equalTo(verificationNumberTextField)
            make.centerY.equalTo(verificationNumberTextField)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalTo(timerLabel.snp.leading).offset(-5*Constants.standardWidth)
            make.centerY.equalTo(verificationNumberTextField)
        }
        
        textFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(verificationNumberTextField.snp.bottom).offset(6*Constants.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*Constants.standardHeight)
        }
    }
}
