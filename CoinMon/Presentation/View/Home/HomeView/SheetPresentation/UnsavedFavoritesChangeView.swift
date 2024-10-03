import UIKit
import SnapKit

class UnsavedFavoritesChangeView: UIView {
    let firstLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        label.text = LocalizationManager.shared.localizedString(forKey: "저장하지 않고 나가시겠어요?")
        return label
    }()
    let secondLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B4_15
        label.textColor = ColorManager.gray_15
        label.text = LocalizationManager.shared.localizedString(forKey: "지금까지 편집한 내용은 저장되지 않아요.")
        return label
    }()
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "이어서 편집"), for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.setTitleColor(ColorManager.gray_20, for: .normal)
        button.backgroundColor = ColorManager.common_100
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorManager.gray_95?.cgColor
        return button
    }()
    let finishButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "나가기"), for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.backgroundColor = ColorManager.orange_60
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [firstLabel,secondLabel,continueButton,finishButton]
            .forEach{
                addSubview($0)
            }
        
        firstLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(40*ConstantsManager.standardHeight)
        }
        
        secondLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(firstLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
        }
        
        continueButton.snp.makeConstraints { make in
            make.width.equalTo(161*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(secondLabel.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        finishButton.snp.makeConstraints { make in
            make.width.equalTo(161*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(secondLabel.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
    }
}
