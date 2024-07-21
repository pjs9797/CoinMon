import UIKit
import SnapKit

class NoneNotificationView: UIView {
    let noneNotificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.noneAlarm
        return imageView
    }()
    let noneNotificationLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B4_15
        label.textColor = ColorManager.gray_70
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        noneNotificationLabel.text = LocalizationManager.shared.localizedString(forKey: "아직 새로운 알림이 없어요")
    }
    
    private func layout() {
        [noneNotificationImageView,noneNotificationLabel]
            .forEach{
                addSubview($0)
            }
        
        noneNotificationImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50*ConstantsManager.standardHeight)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
        }
        
        noneNotificationLabel.snp.makeConstraints { make in
            make.width.equalTo(273*ConstantsManager.standardWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(noneNotificationImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
    }
}
