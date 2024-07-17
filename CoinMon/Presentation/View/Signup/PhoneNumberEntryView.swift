import UIKit
import SnapKit

class PhoneNumberEntryView: UIView {
    let enterPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D2_24
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_40
        return label
    }()
    let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.H2_20
        textField.textColor = ColorManager.common_0
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
        view.backgroundColor = ColorManager.gray_90
        return view
    }()
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
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
        enterPhoneNumberLabel.text = LocalizationManager.shared.localizedString(forKey: "휴대폰번호를 입력해주세요")
        phoneNumberLabel.text = LocalizationManager.shared.localizedString(forKey: "휴대폰번호")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ColorManager.gray_70 ?? UIColor.gray
        ]
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: LocalizationManager.shared.localizedString(forKey: "숫자만 입력"), attributes: attributes)
        nextButton.setTitle(LocalizationManager.shared.localizedString(forKey: "다음"), for: .normal)
    }
    
    private func layout() {
        [enterPhoneNumberLabel,phoneNumberLabel,phoneNumberTextField,clearButton,textFieldLineView,nextButton]
            .forEach{
                addSubview($0)
            }
        
        enterPhoneNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*ConstantsManager.standardHeight)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(enterPhoneNumberLabel.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalTo(phoneNumberTextField)
            make.centerY.equalTo(phoneNumberTextField)
        }
        
        textFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
    }
}
