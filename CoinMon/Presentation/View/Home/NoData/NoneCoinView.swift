import UIKit
import SnapKit

class NoneCoinView: UIView {
    let noneCoinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.nosearch
        return imageView
    }()
    let noneCoinLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B3_16
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
        noneCoinLabel.text = LocalizationManager.shared.localizedString(forKey: "검색한 코인이 없어요")
    }
    
    private func layout() {
        [noneCoinImageView,noneCoinLabel]
            .forEach{
                addSubview($0)
            }
        
        noneCoinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50*ConstantsManager.standardHeight)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
        }
        
        noneCoinLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(noneCoinImageView.snp.bottom).offset(14*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-46*ConstantsManager.standardHeight)
        }
    }
}
