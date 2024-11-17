import UIKit
import SnapKit

class IsNotSetTestAlarmView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "알림을 아직 설정하지 않았어요")
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.B4_15
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "설정 > 알림에서 코인몬 알림을 허용해 주세요"))
        label.textColor = ColorManager.gray_15
        label.numberOfLines = 0
        return label
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.isReceivedTestAlarm
        return imageView
    }()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12*ConstantsManager.standardWidth
        return stackView
    }()
    let laterButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "다음에 하기"), for: .normal)
        button.setTitleColor(ColorManager.gray_20, for: .normal)
        button.titleLabel?.font = FontManager.D6_16
        button.backgroundColor = ColorManager.common_100
        button.layer.cornerRadius = 12*ConstantsManager.standardHeight
        button.layer.borderColor = ColorManager.gray_95?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let setAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "알림 설정하기"), for: .normal)
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
        [titleLabel,subTitleLabel,imageView,buttonStackView]
            .forEach{
                addSubview($0)
            }
        
        [laterButton,setAlarmButton]
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
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(142*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(imageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
    }
}
