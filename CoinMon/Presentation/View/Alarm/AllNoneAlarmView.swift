import UIKit
import SnapKit

class AllNoneAlarmView: UIView {
    let noneAlarmImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.noneAlarm
        return imageView
    }()
    let noneAlarmLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B4_15
        label.textColor = ColorManager.gray_70
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    let addAlarmButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.backgroundColor = ColorManager.orange_60
        button.layer.cornerRadius = 12 * ConstantsManager.standardHeight
        button.titleLabel?.font = FontManager.D6_16
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        noneAlarmLabel.text = LocalizationManager.shared.localizedString(forKey: "아직 추가한 알람이 없어요")
        addAlarmButton.setTitle(LocalizationManager.shared.localizedString(forKey: "알람 추가하기"), for: .normal)
    }
    
    private func layout() {
        [noneAlarmImageView,noneAlarmLabel,addAlarmButton]
            .forEach{
                addSubview($0)
            }
        
        noneAlarmImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50*ConstantsManager.standardHeight)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
        }
        
        noneAlarmLabel.snp.makeConstraints { make in
            make.width.equalTo(263*ConstantsManager.standardWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(noneAlarmImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        addAlarmButton.snp.makeConstraints { make in
            make.height.equalTo(44*ConstantsManager.standardHeight)
            make.top.equalTo(noneAlarmLabel.snp.bottom).offset(20*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
        }
    }
}
