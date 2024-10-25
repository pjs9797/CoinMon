import UIKit
import SnapKit

class SelectCycleForIndicatorView: UIView {
    let indicatorLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.gray_30
        return label
    }()
    let explainButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_questionMark18, for: .normal)
        return button
    }()
    let premiumLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium"
        label.font = FontManager.D8_14
        label.textColor = ColorManager.gray_40
        return label
    }()
    let premiumExplainLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "15분 주기로 매수•매도 타이밍을\n확인하고 알려드려요")
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let freeExplainLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "15분 주기로 확인하고 알려드려요")
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    let freeExplainSubLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "코인별 변동성에 따라 최대 일주일 주기로 알림이 갈 수 있어요")
        label.font = FontManager.B4_15
        label.textColor = ColorManager.gray_15
        label.numberOfLines = 0
        return label
    }()
    let explainImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let completeButton: BottomButton = {
        let button = BottomButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "완료"), for: .normal)
        button.isEnable()
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
        [indicatorLabel,explainButton,premiumLabel,premiumExplainLabel,freeExplainLabel,freeExplainSubLabel,explainImageView,completeButton]
            .forEach{
                addSubview($0)
            }
        
        indicatorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        explainButton.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalTo(indicatorLabel.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorLabel)
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.leading.equalTo(explainButton.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorLabel)
        }
        
        premiumExplainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        freeExplainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        freeExplainSubLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(freeExplainLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
        }
        
        explainImageView.snp.makeConstraints { make in
            make.height.equalTo(360*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorLabel.snp.bottom).offset(140*ConstantsManager.standardHeight)
        }
        
        completeButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8*ConstantsManager.standardHeight)
        }
    }
}
