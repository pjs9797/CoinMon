import UIKit
import SnapKit

class NewIndicatorView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.D4_20
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "코인몬 지표 구독 오픈!"))
        label.textColor = ColorManager.common_0
        return label
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.B4_15
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "매수•매도 타이밍 알림을 받을 수 있어요"))
        label.textColor = ColorManager.gray_15
        label.numberOfLines = 0
        return label
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.newIndicator
        return imageView
    }()
    let trialButton: BottomButton = {
        let button = BottomButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "14일 무료 체험하기"), for: .normal)
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
        [titleLabel,subTitleLabel,imageView,trialButton]
            .forEach{
                addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(28*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(32*ConstantsManager.standardHeight)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(23*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(150*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        trialButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(imageView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
    }
}
