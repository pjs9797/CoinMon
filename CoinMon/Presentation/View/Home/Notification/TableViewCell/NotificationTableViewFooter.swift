import UIKit
import SnapKit

class NotificationTableViewFooter: UIView {
    let notificationTableViewFooterLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.gray_70
        label.font = FontManager.T6_13
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        setLocalizedText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        notificationTableViewFooterLabel.text = LocalizationManager.shared.localizedString(forKey: "최근 30일간 알림을 표시합니다")
    }
    
    private func layout() {
        self.addSubview(notificationTableViewFooterLabel)
        
        notificationTableViewFooterLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
