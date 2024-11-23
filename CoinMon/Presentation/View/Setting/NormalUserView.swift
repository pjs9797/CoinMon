import UIKit
import SnapKit

class NormalUserView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.H3_18
        label.textColor = ColorManager.common_0
        label.textAlignment = .center
        return label
    }()
    lazy var trialButton: UIButton = {
        let button = ConfigurationButton(font: FontManager.H4_16, foregroundColor: ColorManager.common_100, backgroundColor: ColorManager.orange_60)
        var configuration = button.configuration
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8*ConstantsManager.standardHeight, leading: 12*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, trailing: 12*ConstantsManager.standardWidth)
        button.configuration = configuration
        button.layer.cornerRadius = 8*ConstantsManager.standardHeight
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorManager.gray_99
        self.layer.cornerRadius = 16*ConstantsManager.standardHeight
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        titleLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "매수•매도 타이밍 알림 Coinmon Premium"))
    }
    
    private func layout() {
        [titleLabel,trialButton]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        trialButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16*ConstantsManager.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(12*ConstantsManager.standardWidth)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
    }
}
