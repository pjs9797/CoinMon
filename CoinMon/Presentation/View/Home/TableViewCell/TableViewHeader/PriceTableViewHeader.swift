import UIKit
import SnapKit

class PriceTableViewHeader: UITableViewHeaderFooterView {
    let coinView: UIView = {
        let view = UIView()
        return view
    }()
    let coinButton: UIButton = {
        let button = UIButton()
        button.setTitle("코인", for: .normal)
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
        button.setTitle("시세(USDT)", for: .normal)
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
        button.setTitle("등락률", for: .normal)
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
        button.setTitle("시평갭", for: .normal)
        button.setTitleColor(ColorManager.gray_50, for: .normal)
        button.titleLabel?.font = FontManager.T7_12_read
        button.setImage(ImageManager.sort, for: .normal)
        button.contentHorizontalAlignment = .right
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [coinView,priceView,changeView,gapView]
            .forEach {
                contentView.addSubview($0)
            }
        
        coinView.addSubview(coinButton)
        priceView.addSubview(priceButton)
        changeView.addSubview(changeButton)
        gapView.addSubview(gapButton)
        
        coinView.snp.makeConstraints { make in
            make.width.equalTo(121*Constants.standardWidth)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        coinButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        priceView.snp.makeConstraints { make in
            make.width.equalTo(90*Constants.standardWidth)
            make.leading.equalTo(coinView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        priceButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        changeView.snp.makeConstraints { make in
            make.width.equalTo(68*Constants.standardWidth)
            make.leading.equalTo(priceView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        changeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gapView.snp.makeConstraints { make in
            make.leading.equalTo(changeView.snp.trailing)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        gapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
