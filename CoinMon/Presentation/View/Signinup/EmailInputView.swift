import UIKit
import SnapKit

class EmailInputView: UIView {
    let enterEmailLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H2_24
        label.textColor = ColorManager.color_neutral_5
        return label
    }()
    let enterUsingEmailLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B4_14
        label.textColor = ColorManager.color_neutral_15
        return label
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_12
        label.textColor = ColorManager.color_neutral_40
        return label
    }()
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.H4_20
        textField.textColor = ColorManager.color_neutral_10
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
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B5_12
        label.textColor = ColorManager.color_error
        return label
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
        enterEmailLabel.text = NSLocalizedString("이메일을 입력해주세요", comment: "")
        enterUsingEmailLabel.text = NSLocalizedString("사용하는 이메일을 입력해주세요", comment: "")
        emailLabel.text = NSLocalizedString("이메일 아이디", comment: "")
        emailErrorLabel.text = NSLocalizedString("올바른 이메일을 입력해주세요", comment: "")
        nextButton.setTitle(NSLocalizedString("다음", comment: ""), for: .normal)
    }
    
    private func layout() {
        [enterEmailLabel,enterUsingEmailLabel,emailLabel,emailTextField,clearButton,textFieldLineView,emailErrorLabel,nextButton]
            .forEach{
                addSubview($0)
            }
        
        enterEmailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*Constants.standardHeight)
        }
        
        enterUsingEmailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(enterEmailLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(enterUsingEmailLabel.snp.bottom).offset(40*Constants.standardHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(emailLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalTo(emailTextField)
            make.centerY.equalTo(emailTextField)
        }
        
        textFieldLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(emailTextField.snp.bottom).offset(6*Constants.standardHeight)
        }
        
        emailErrorLabel.snp.makeConstraints { make in
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
