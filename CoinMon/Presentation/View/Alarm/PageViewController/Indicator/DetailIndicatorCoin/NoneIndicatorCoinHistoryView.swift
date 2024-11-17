import UIKit
import SnapKit

class NoneIndicatorCoinHistoryView: UIView {
    let noneHistoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_Chat50
        return imageView
    }()
    let noneHistoryLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.B4_15
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "아직 히스토리가 없어요\n매수•매도 타이밍일 때 알려 드릴게요"))
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
    
    private func layout() {
        [noneHistoryImageView,noneHistoryLabel]
            .forEach{
                addSubview($0)
            }
        
        noneHistoryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50*ConstantsManager.standardHeight)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
        }
        
        noneHistoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noneHistoryImageView.snp.bottom).offset(12*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
    }
}
