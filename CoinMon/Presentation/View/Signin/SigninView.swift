import UIKit
import SnapKit

class SigninView: UIView {
    let coinMonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.loginCoinMon
        return imageView
    }()
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorManager.yellow_70
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        var config = UIButton.Configuration.plain()
        config.image = ImageManager.kakao
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = FontManager.D6_16
            outgoing.foregroundColor = ColorManager.common_0
            return outgoing
        }
        config.imagePadding = 4*ConstantsManager.standardWidth
        button.configuration = config
        return button
    }()
    let appleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorManager.common_0
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        var config = UIButton.Configuration.plain()
        config.image = ImageManager.apple
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = FontManager.D6_16
            outgoing.foregroundColor = ColorManager.common_100
            return outgoing
        }
        config.imagePadding = 4*ConstantsManager.standardWidth
        button.configuration = config
        return button
    }()
    let coinMonLoginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.backgroundColor = ColorManager.gray_97
        button.accessibilityIdentifier = "coinMonLoginButton"
        return button
    }()
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.gray_70, for: .normal)
        button.titleLabel?.font = FontManager.B7_12
        return button
    }()
    let languageSettingButton: LanguageSettingButton = {
        let button = LanguageSettingButton()
        button.setTitleColor(ColorManager.gray_60, for: .normal)
        button.titleLabel?.font = FontManager.T5_14
        return button
    }()
    let completeWithdrawalToast: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_10
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return view
    }()
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.check24
        return imageView
    }()
    let toastLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T3_16
        label.textColor = ColorManager.common_100
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLocalizedText()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        kakaoLoginButton.setTitle(LocalizationManager.shared.localizedString(forKey: "카카오로 계속하기"), for: .normal)
        appleLoginButton.setTitle(LocalizationManager.shared.localizedString(forKey: "애플로 계속하기"), for: .normal)
        coinMonLoginButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인몬 아이디로 계속하기"), for: .normal)
        signupButton.setTitle(LocalizationManager.shared.localizedString(forKey: "회원가입"), for: .normal)
        signupButton.setUnderline()
        toastLabel.text = LocalizationManager.shared.localizedString(forKey: "계정 삭제 toast")
    }
    
    private func layout() {
        [coinMonImageView,kakaoLoginButton,appleLoginButton,coinMonLoginButton,signupButton,languageSettingButton,completeWithdrawalToast]
            .forEach{
                addSubview($0)
            }
        
        [checkImageView,toastLabel]
            .forEach{
                completeWithdrawalToast.addSubview($0)
            }
        
        coinMonImageView.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(300*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20*ConstantsManager.standardHeight)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(coinMonImageView.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        kakaoLoginButton.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(kakaoLoginButton.titleLabel!.snp.leading).offset(-4*ConstantsManager.standardWidth)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        appleLoginButton.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(appleLoginButton.titleLabel!.snp.leading).offset(-4*ConstantsManager.standardWidth)
        }
        
        coinMonLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(appleLoginButton.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        signupButton.snp.makeConstraints { make in
            make.width.equalTo(66*ConstantsManager.standardWidth)
            make.height.equalTo(34*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(coinMonLoginButton.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        languageSettingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20*ConstantsManager.standardHeight)
        }
        
        completeWithdrawalToast.snp.makeConstraints { make in
            make.height.equalTo(48*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-24*ConstantsManager.standardHeight)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(checkImageView)
        }
    }
}
