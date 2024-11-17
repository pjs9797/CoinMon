import UIKit
import SnapKit

class NoneFavoritesView: UIView {
    let noneFavoritesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.Star50
        return imageView
    }()
    let noneFavoritesLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.B4_15
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
    
    func setLocalizedText(){
        noneFavoritesLabel.text = LocalizationManager.shared.localizedString(forKey: "이 거래소는 즐겨찾는 코인이 없어요")
    }
    
    private func layout() {
        [noneFavoritesImageView,noneFavoritesLabel]
            .forEach{
                addSubview($0)
            }
        
        noneFavoritesImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50*ConstantsManager.standardHeight)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
        }
        
        noneFavoritesLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(noneFavoritesImageView.snp.bottom).offset(14*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-46*ConstantsManager.standardHeight)
        }
    }
}
