import UIKit
import SnapKit

class WithdrawalView: UIView {
    let firstNoticeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D5_18
        label.textColor = ColorManager.common_0
        return label
    }()
    let secondNoticeLabel: UILabel = {
        let label = UILabel()
        //label.font = FontManager.B5_14
        label.setAttributedText(FontsManager.B5_14)
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.square_Check_None, for: .normal)
        return button
    }()
    let checkNoticeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T4_15
        label.textColor = ColorManager.common_0
        return label
    }()
    let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12*Constants.standardHeight
        button.titleLabel?.font = FontManager.D6_16
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
        firstNoticeLabel.text = LocalizationManager.shared.localizedString(forKey: "회원탈퇴설명1")
        secondNoticeLabel.text = LocalizationManager.shared.localizedString(forKey: "회원탈퇴설명2")
        checkNoticeLabel.text = LocalizationManager.shared.localizedString(forKey: "회원탈퇴설명3")
        withdrawalButton.setTitle(LocalizationManager.shared.localizedString(forKey: "탈퇴하기"), for: .normal)
    }
    
    private func layout() {
        [firstNoticeLabel,secondNoticeLabel,checkButton,checkNoticeLabel,withdrawalButton]
            .forEach{
                addSubview($0)
            }
        
        firstNoticeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(32*Constants.standardHeight)
        }
        
        secondNoticeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(firstNoticeLabel.snp.bottom).offset(30*Constants.standardHeight)
        }
        
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalTo(secondNoticeLabel.snp.bottom).offset(50*Constants.standardHeight)
        }
        
        checkNoticeLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(10*Constants.standardWidth)
            make.centerY.equalTo(checkButton)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*Constants.standardHeight)
        }
    }
}
