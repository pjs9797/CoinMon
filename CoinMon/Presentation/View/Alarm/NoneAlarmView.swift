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
        label.font = FontManager.B3_16
        label.textColor = ColorManager.gray_70
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
            make.width.height.equalTo(50*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16*Constants.standardHeight)
        }
        
        noneAlarmLabel.snp.makeConstraints { make in
            make.width.equalTo(230*Constants.standardWidth)
            make.centerX.equalToSuperview()
            make.top.equalTo(noneAlarmImageView.snp.bottom).offset(16*Constants.standardHeight)
        }
    }
}