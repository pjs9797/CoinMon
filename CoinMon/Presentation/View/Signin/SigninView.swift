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
        button.layer.cornerRadius = 12*Constants.standardHeight
        var config = UIButton.Configuration.plain()
        config.image = ImageManager.kakao
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = FontManager.D6_16
            outgoing.foregroundColor = ColorManager.common_0
            return outgoing
        }
        config.imagePadding = 4*Constants.standardWidth
        button.configuration = config
        button.isHidden = true
        return button
    }()
    let appleLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ColorManager.common_0
        button.layer.cornerRadius = 12*Constants.standardHeight
        var config = UIButton.Configuration.plain()
        config.image = ImageManager.apple
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = FontManager.D6_16
            outgoing.foregroundColor = ColorManager.common_100
            return outgoing
        }
        config.imagePadding = 4*Constants.standardWidth
        button.configuration = config
        button.isHidden = true
        return button
    }()
    let coinMonLoginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.layer.cornerRadius = 12*Constants.standardHeight
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorManager.gray_95?.cgColor
        button.backgroundColor = ColorManager.gray_97
        return button
    }()
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.gray_70, for: .normal)
        button.titleLabel?.font = FontManager.B7_12
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLocalizedText()
        layout()
        signupButton.setUnderline()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLocalizedText(){
        kakaoLoginButton.setTitle(LocalizationManager.shared.localizedString(forKey: "카카오로 계속하기"), for: .normal)
        appleLoginButton.setTitle(LocalizationManager.shared.localizedString(forKey: "애플로 계속하기"), for: .normal)
        coinMonLoginButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인몬 아이디로 계속하기"), for: .normal)
        signupButton.setTitle(LocalizationManager.shared.localizedString(forKey: "회원가입"), for: .normal)
    }
    
    private func layout() {
        [coinMonImageView,kakaoLoginButton,appleLoginButton,coinMonLoginButton,signupButton]
            .forEach{
                addSubview($0)
            }
        
        coinMonImageView.snp.makeConstraints { make in
            make.width.equalTo(335*Constants.standardWidth)
            make.height.equalTo(300*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20*Constants.standardHeight)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*Constants.standardWidth)
            make.height.equalTo(52*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(coinMonImageView.snp.bottom).offset(40*Constants.standardHeight)
        }
        
        kakaoLoginButton.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(kakaoLoginButton.titleLabel!.snp.leading).offset(-4*Constants.standardWidth)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*Constants.standardWidth)
            make.height.equalTo(52*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        appleLoginButton.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(appleLoginButton.titleLabel!.snp.leading).offset(-4*Constants.standardWidth)
        }
        
        coinMonLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*Constants.standardWidth)
            make.height.equalTo(52*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(appleLoginButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        signupButton.snp.makeConstraints { make in
            make.width.equalTo(66*Constants.standardWidth)
            make.height.equalTo(34*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(coinMonLoginButton.snp.bottom).offset(40*Constants.standardHeight)
        }
    }
}
