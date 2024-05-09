import UIKit
import SnapKit

class SigninView: UIView {
    let coinMonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = ColorManager.color_neutral_90
        return imageView
    }()
    let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontManager.H6_16
        button.setImage(ImageManager.kakao, for: .normal)
        button.backgroundColor = ColorManager.color_kakao
        button.layer.cornerRadius = 12*Constants.standardHeight
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4*Constants.standardWidth
        button.configuration = config
        return button
    }()
    let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontManager.H6_16
        button.setImage(ImageManager.apple, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12*Constants.standardHeight
        var config = UIButton.Configuration.plain()
        config.imagePadding = 4*Constants.standardWidth
        button.configuration = config
        return button
    }()
    let coinMonLoginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontManager.H6_16
        button.layer.cornerRadius = 12*Constants.standardHeight
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorManager.color_neutral_90?.cgColor
        return button
    }()
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontManager.B5_12
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
        kakaoLoginButton.setTitle(NSLocalizedString("카카오로 계속하기", comment: ""), for: .normal)
        appleLoginButton.setTitle(NSLocalizedString("애플로 계속하기", comment: ""), for: .normal)
        coinMonLoginButton.setTitle(NSLocalizedString("코인몬 아이디로 계속하기", comment: ""), for: .normal)
        signupButton.setTitle(NSLocalizedString("회원가입", comment: ""), for: .normal)
        signupButton.setUnderline()
    }
    
    private func layout() {
        [coinMonImageView,kakaoLoginButton,appleLoginButton,coinMonLoginButton,signupButton]
            .forEach{
                addSubview($0)
            }
        
        coinMonImageView.snp.makeConstraints { make in
            make.width.height.equalTo(220*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*Constants.standardHeight)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*Constants.standardWidth)
            make.height.equalTo(52*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(coinMonImageView.snp.bottom).offset(40*Constants.standardHeight)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.width.equalTo(335*Constants.standardWidth)
            make.height.equalTo(52*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(12*Constants.standardHeight)
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
