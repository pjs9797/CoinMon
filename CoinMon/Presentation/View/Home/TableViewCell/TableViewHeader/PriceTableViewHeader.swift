import UIKit
import SnapKit

class PriceTableViewHeader: UIView {
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
    let priceView: UIView = {
        let view = UIView()
        return view
    }()
    let priceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.gray_50, for: .normal)
        button.titleLabel?.font = FontManager.T7_12_read
        button.setImage(ImageManager.sort, for: .normal)
        button.contentHorizontalAlignment = .right
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    let changeView: UIView = {
        let view = UIView()
        return view
    }()
    let changeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.gray_50, for: .normal)
        button.titleLabel?.font = FontManager.T7_12_read
        button.setImage(ImageManager.sort, for: .normal)
        button.contentHorizontalAlignment = .right
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    let gapView: UIView = {
        let view = UIView()
        return view
    }()
    let gapButton: UIButton = {
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
        [coinView,priceView,changeView,gapView]
            .forEach {
                addSubview($0)
            }
        
        coinView.addSubview(coinButton)
        priceView.addSubview(priceButton)
        changeView.addSubview(changeButton)
        gapView.addSubview(gapButton)
        
        coinView.snp.makeConstraints { make in
            make.width.equalTo(121*ConstantsManager.standardWidth)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        coinButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        priceView.snp.makeConstraints { make in
            make.width.equalTo(90*ConstantsManager.standardWidth)
            make.leading.equalTo(coinView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        priceButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        changeView.snp.makeConstraints { make in
            make.width.equalTo(68*ConstantsManager.standardWidth)
            make.leading.equalTo(priceView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        changeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gapView.snp.makeConstraints { make in
            make.leading.equalTo(changeView.snp.trailing)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        gapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
