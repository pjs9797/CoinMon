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
        
        backgroundColor = .systemBackground
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(noneAlarmImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
    }
}
