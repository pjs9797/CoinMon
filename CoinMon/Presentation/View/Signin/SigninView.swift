import UIKit
import SnapKit

class SigninView: UIView {
    let coinMonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.loginCoinMon
        return imageView
    }()
    let kakaoLoginButton: BaseButton = {
        let button = BaseButton()
        button.setConfiguration(title: "", fontStyle: FontManagerA.D6_16, foregroundColor: ColorManager.yellow_70, backgroundColor: ColorManager.common_0)
        button.setImage(image: ImageManager.kakao, padding: 4)
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.isHidden = true
        return button
    }()
    let appleLoginButton: BaseButton = {
        let button = BaseButton()
        button.setConfiguration(title: "", fontStyle: FontManagerA.D6_16, foregroundColor: ColorManager.common_100, backgroundColor: ColorManager.common_0)
        button.setImage(image: ImageManager.apple, padding: 4)
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.isHidden = true
        return button
    }()
    let coinMonLoginButton: BaseButton = {
        let button = BaseButton()
        button.setConfiguration(title: "", fontStyle: FontManagerA.D6_16, foregroundColor: ColorManager.common_0, backgroundColor: ColorManager.gray_97)
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.accessibilityIdentifier = "coinMonLoginButton"
        return button
    }()
    let signupButton: BaseButton = {
        let button = BaseButton()
        button.setConfiguration(title: LocalizationManager.shared.localizedString(forKey: "회원가입"), fontStyle: FontManagerA.T4_15, foregroundColor: ColorManager.gray_50)
        button.setUnderline()
        return button
    }()
    let languageSettingButton: LanguageSettingButton = {
        let button = LanguageSettingButton()
        return button
    }()
    let completeWithdrawalToast: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_10
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.isHidden = true
        return view
    }()
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.check24
        return imageView
    }()
    let toastLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: "", fontStyle: FontManagerA.T3_16, textColor: ColorManager.common_100)
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
        kakaoLoginButton.updateTitle(LocalizationManager.shared.localizedString(forKey: "카카오로 계속하기"))
        appleLoginButton.updateTitle(LocalizationManager.shared.localizedString(forKey: "애플로 계속하기"))
        coinMonLoginButton.updateTitle(LocalizationManager.shared.localizedString(forKey: "코인몬 아이디로 계속하기"))
        signupButton.updateTitle(LocalizationManager.shared.localizedString(forKey: "회원가입"))
        signupButton.setUnderline()
        toastLabel.updateText(LocalizationManager.shared.localizedString(forKey: "계정 삭제 toast"))
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
        
        appleLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        coinMonLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(appleLoginButton.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        signupButton.snp.makeConstraints { make in
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
