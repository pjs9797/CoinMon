import UIKit
import SnapKit

class MyAccountView: UIView {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage1")
        imageView.layer.cornerRadius = 50*ConstantsManager.standardHeight
        return imageView
    }()
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.font = FontManager.H3_18
        textField.textColor = ColorManager.common_0
        textField.text = "CoinMon"
        textField.layer.cornerRadius = 8*ConstantsManager.standardHeight
        textField.layer.borderWidth = 1
        return textField
    }()
    let changeNicknameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.titleLabel?.font = FontManager.H4_16
        button.backgroundColor = ColorManager.orange_60
        button.layer.cornerRadius = 8*ConstantsManager.standardHeight
        return button
    }()
    let nicknameErrorLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B7_12
        label.textColor = ColorManager.gray_80
        return label
    }()
    let loginAccountLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.gray_30
        return label
    }()
    let loginTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.kakao
        imageView.backgroundColor = ColorManager.yellow_70
        imageView.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return imageView
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T3_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.titleLabel?.font = FontManager.H4_16
        button.contentHorizontalAlignment = .leading
        return button
    }()
    let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.titleLabel?.font = FontManager.H4_16
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        changeNicknameButton.setTitle(LocalizationManager.shared.localizedString(forKey: "닉네임 변경"), for: .normal)
        nicknameErrorLabel.text = LocalizationManager.shared.localizedString(forKey: "최대 12자까지 가능해요")
        loginAccountLabel.text = LocalizationManager.shared.localizedString(forKey: "로그인 계정")
        logoutButton.setTitle(LocalizationManager.shared.localizedString(forKey: "로그아웃"), for: .normal)
        withdrawalButton.setTitle(LocalizationManager.shared.localizedString(forKey: "회원탈퇴"), for: .normal)
    }
    
    private func layout() {
        [profileImageView,nicknameTextField,changeNicknameButton,nicknameErrorLabel,loginAccountLabel,loginTypeImageView,emailLabel,logoutButton,withdrawalButton]
            .forEach{
                addSubview($0)
            }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.width.equalTo(220*ConstantsManager.standardWidth)
            make.height.equalTo(40*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(profileImageView.snp.bottom).offset(27*ConstantsManager.standardHeight)
        }
        
        changeNicknameButton.snp.makeConstraints { make in
            make.width.equalTo(97*ConstantsManager.standardWidth)
            make.height.equalTo(40*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(nicknameTextField)
        }
        
        nicknameErrorLabel.snp.makeConstraints { make in
            make.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(changeNicknameButton.snp.bottom)
        }
        
        loginAccountLabel.snp.makeConstraints { make in
            make.height.equalTo(22*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(changeNicknameButton.snp.bottom).offset(58*ConstantsManager.standardHeight)
        }
        
        loginTypeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(loginAccountLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(loginTypeImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(loginTypeImageView)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(loginAccountLabel.snp.bottom).offset(132*ConstantsManager.standardHeight)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(logoutButton.snp.bottom)
        }
    }
}
