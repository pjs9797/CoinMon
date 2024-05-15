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
        imageView.layer.cornerRadius = 119*Constants.standardHeight
        imageView.backgroundColor = ColorManager.gray_60
        return imageView
    }()
    let signupCompletedButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = ColorManager.orange_60
        button.layer.cornerRadius = 12*Constants.standardHeight
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
        signupCompletedLabel.text = NSLocalizedString("회원가입 완료", comment: "")
        signupCompletedButton.setTitle(NSLocalizedString("코인몬 시작하기", comment: ""), for: .normal)
    }
    
    private func layout() {
        [signupCompletedLabel,profileImageView,signupCompletedButton]
            .forEach{
                addSubview($0)
            }
        
        signupCompletedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40*Constants.standardHeight)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(238*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(signupCompletedLabel.snp.bottom).offset(80*Constants.standardHeight)
        }
        
        signupCompletedButton.snp.makeConstraints { make in
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*Constants.standardHeight)
        }
    }
}
