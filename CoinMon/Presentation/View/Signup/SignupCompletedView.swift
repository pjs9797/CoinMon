import UIKit
import SnapKit

class SignupCompletedView: UIView {
    let signupCompletedLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D2_24
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50*ConstantsManager.standardHeight
        imageView.image = ImageManager.check_Yellow
        return imageView
    }()
    let signupCompletedButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.backgroundColor = ColorManager.orange_60
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
        signupCompletedLabel.text = LocalizationManager.shared.localizedString(forKey: "회원가입 완료! 🎉")
        signupCompletedButton.setTitle(LocalizationManager.shared.localizedString(forKey: "완료"), for: .normal)
    }
    
    private func layout() {
        [signupCompletedLabel,profileImageView,signupCompletedButton]
            .forEach{
                addSubview($0)
            }
        
        signupCompletedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*ConstantsManager.standardHeight)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(signupCompletedLabel.snp.bottom).offset(80*ConstantsManager.standardHeight)
        }
        
        signupCompletedButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
    }
}
