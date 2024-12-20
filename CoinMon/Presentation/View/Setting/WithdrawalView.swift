import UIKit
import SnapKit

class WithdrawalView: UIView {
    let firstNoticeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.D5_18
        label.textColor = ColorManager.common_0
        return label
    }()
    let secondNoticeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.B5_14
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
        label.attributedText = AttributedFontManager.T4_15
        label.textColor = ColorManager.common_0
        return label
    }()
    let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
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
        firstNoticeLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "회원탈퇴설명1"))
        secondNoticeLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "회원탈퇴설명2"))
        checkNoticeLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "회원탈퇴설명3"))
        withdrawalButton.setTitle(LocalizationManager.shared.localizedString(forKey: "탈퇴하기"), for: .normal)
    }
    
    private func layout() {
        [firstNoticeLabel,secondNoticeLabel,checkButton,checkNoticeLabel,withdrawalButton]
            .forEach{
                addSubview($0)
            }
        
        firstNoticeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(32*ConstantsManager.standardHeight)
        }
        
        secondNoticeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(firstNoticeLabel.snp.bottom).offset(30*ConstantsManager.standardHeight)
        }
        
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(secondNoticeLabel.snp.bottom).offset(50*ConstantsManager.standardHeight)
        }
        
        checkNoticeLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(10*ConstantsManager.standardWidth)
            make.centerY.equalTo(checkButton)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
    }
}
