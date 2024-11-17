import UIKit
import SnapKit

class ResendTestAlarmView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "테스트 알림을 다시 보내 드릴게요")
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
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
    let receiveButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "알림 다시 받기"), for: .normal)
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
        [titleLabel,imageView,buttonStackView]
            .forEach{
                addSubview($0)
            }
        
        [laterButton,receiveButton]
            .forEach{
                buttonStackView.addArrangedSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(28*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(32*ConstantsManager.standardHeight)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(142*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(imageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
    }
}
