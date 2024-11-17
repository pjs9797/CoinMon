import UIKit
import SnapKit

class NoneAlarmView: UIView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = ColorManager.common_100
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        noneAlarmLabel.text = LocalizationManager.shared.localizedString(forKey: "아직 추가한 알람이 없어요")
    }
    
    private func layout() {
        [noneAlarmImageView,noneAlarmLabel]
            .forEach{
                addSubview($0)
            }
        
        noneAlarmImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50*ConstantsManager.standardHeight)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
        }
        
        noneAlarmLabel.snp.makeConstraints { make in
            make.width.equalTo(273*ConstantsManager.standardWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(noneAlarmImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
    }
}
