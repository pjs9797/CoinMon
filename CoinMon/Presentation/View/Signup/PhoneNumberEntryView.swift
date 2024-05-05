import UIKit
import SnapKit

class PhoneNumberEntryView: UIView {
    let enterPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H2_24
        label.numberOfLines = 0
        return label
    }()
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_12
        label.textColor = ColorManager.color_neutral_40
        return label
    }()
    let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.H4_20
        textField.keyboardType = .numberPad
        return textField
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLocalizedText()
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLocalizedText()
        layout()
    }
    
    private func setLocalizedText(){
        enterPhoneNumberLabel.text = NSLocalizedString("휴대폰번호를 입력해주세요", comment: "")
        phoneNumberLabel.text = NSLocalizedString("휴대폰번호", comment: "")
        phoneNumberTextField.placeholder = NSLocalizedString("숫자만 입력", comment: "")
        nextButton.setTitle(NSLocalizedString("다음", comment: ""), for: .normal)
    }
    
    private func layout() {
        [enterPhoneNumberLabel,phoneNumberLabel,phoneNumberTextField,clearButton,textFieldLineView,nextButton]
            .forEach{
                addSubview($0)
            }
        
        enterPhoneNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*Constants.standardHeight)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(enterPhoneNumberLabel.snp.bottom).offset(40*Constants.standardHeight)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalTo(phoneNumberTextField)
            make.centerY.equalTo(phoneNumberTextField)
        }
        
        textFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(6*Constants.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*Constants.standardHeight)
        }
    }
}
