
import UIKit
import SnapKit

class IsRealPopView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "다음에 설정할까요?")
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "지금까지 설정한 내용은 저장되지 않아요")
        label.font = FontManager.B4_15
        label.textColor = ColorManager.gray_15
        return label
    }()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12*ConstantsManager.standardWidth
        return stackView
    }()
    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "이어서 등록"), for: .normal)
        button.setTitleColor(ColorManager.gray_20, for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.backgroundColor = ColorManager.common_100
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.layer.borderColor = ColorManager.gray_95?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let outButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "나가기"), for: .normal)
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.titleLabel?.font = FontManager.D6_16
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
        [titleLabel,subTitleLabel,buttonStackView]
            .forEach{
                addSubview($0)
            }
        
        [continueButton,outButton]
            .forEach{
                buttonStackView.addArrangedSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(28*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(32*ConstantsManager.standardHeight)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(23*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
    }
}
