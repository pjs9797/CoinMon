import UIKit
import SnapKit

class VerificationNumberView: UIView {
    let flowState: EmailEntryFlow
    let enterVerificationNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H2_24
        label.textColor = ColorManager.color_neutral_5
        label.numberOfLines = 0
        return label
    }()
    let sentVerificationNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B4_14
        label.textColor = ColorManager.color_neutral_60
        label.numberOfLines = 0
        return label
    }()
    let verificationNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_12
        label.textColor = ColorManager.color_neutral_40
        return label
    }()
    let verificationNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.H4_20
        textField.textColor = ColorManager.color_neutral_10
        return textField
    }()
    let timerLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_12
        label.textColor = ColorManager.primary
        return label
    }()
    let clearButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.iconClear, for: .normal)
        return button
    }()
    let textFieldLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.color_neutral_90
        return view
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12*Constants.standardHeight
        button.titleLabel?.font = FontManager.H6_16
        return button
    }()
    
    init(flowState: EmailEntryFlow) {
        self.flowState = flowState
        super.init(frame: .zero)
        setLocalizedText()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLocalizedText(){
        enterVerificationNumberLabel.text = NSLocalizedString("인증번호를 입력해주세요", comment: "")
        switch flowState {
        case .Signup:
            sentVerificationNumberLabel.text = String(format: NSLocalizedString("에 인증번호를 보냈어요", comment: ""), UserCredentialsManager.shared.phoneNumber)
        case .Signin:
            sentVerificationNumberLabel.text = String(format: NSLocalizedString("에 인증번호를 보냈어요", comment: ""), UserCredentialsManager.shared.email)
        }
        verificationNumberLabel.text = NSLocalizedString("인증번호", comment: "")
        verificationNumberTextField.placeholder = NSLocalizedString("6자리 인증번호 입력", comment: "")
        nextButton.setTitle(NSLocalizedString("다음", comment: ""), for: .normal)
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
