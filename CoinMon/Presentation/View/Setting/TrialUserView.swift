import UIKit
import SnapKit

class TrialUserView: UIView {
    let statusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.backgroundColor = ColorManager.orange_95
        return view
    }()
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D9_13
        label.textColor = ColorManager.orange_60
        return label
    }()
    let premiumLabel: UILabel = {
        let label = UILabel()
        label.text = "Coinmon Premium"
        label.font = FontManager.D6_16
        label.textColor = ColorManager.common_0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorManager.orange_99
        self.layer.cornerRadius = 16*ConstantsManager.standardHeight
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        statusLabel.text = LocalizationManager.shared.localizedString(forKey: "14일 체험 중")
    }
    
    private func layout() {
        [statusView,premiumLabel]
            .forEach{
                addSubview($0)
            }
        statusView.addSubview(statusLabel)
        
        statusView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8*ConstantsManager.standardWidth)
            make.top.bottom.equalToSuperview().inset(3*ConstantsManager.standardHeight)
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusView.snp.trailing).offset(6*ConstantsManager.standardWidth)
            make.centerY.equalTo(statusView)
        }
    }
}
