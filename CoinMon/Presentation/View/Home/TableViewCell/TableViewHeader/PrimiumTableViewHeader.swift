import UIKit
import SnapKit

class PremiumTableViewHeader: UIView {
    let coinView: UIView = {
        let view = UIView()
        return view
    }()
    let coinButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.gray_50, for: .normal)
        button.titleLabel?.font = FontManager.T7_12_read
        button.setImage(ImageManager.sort, for: .normal)
        button.contentHorizontalAlignment = .left
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    let premiumView: UIView = {
        let view = UIView()
        return view
    }()
    let premiumButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.gray_50, for: .normal)
        button.titleLabel?.font = FontManager.T7_12_read
        button.setImage(ImageManager.sort, for: .normal)
        button.contentHorizontalAlignment = .right
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [coinView,premiumView]
            .forEach {
                addSubview($0)
            }
        
        coinView.addSubview(coinButton)
        premiumView.addSubview(premiumButton)
        
        coinView.snp.makeConstraints { make in
            make.width.equalTo(121*ConstantsManager.standardWidth)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        coinButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        premiumView.snp.makeConstraints { make in
            make.width.equalTo(100*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        premiumButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
