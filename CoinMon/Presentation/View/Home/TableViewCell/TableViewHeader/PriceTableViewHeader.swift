import UIKit
import SnapKit

class PriceTableViewHeader: UITableViewHeaderFooterView {
    let coinView: UIView = {
        let view = UIView()
        return view
    }()
    let coinLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T7_12_read
        label.textColor = ColorManager.gray_50
        label.textAlignment = .left
        return label
    }()
    let priceView: UIView = {
        let view = UIView()
        return view
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T7_12_read
        label.textColor = ColorManager.gray_50
        return label
    }()
    let priceSortImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.sort
        return imageView
    }()
    let changeView: UIView = {
        let view = UIView()
        return view
    }()
    let changeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T7_12_read
        label.textColor = ColorManager.gray_50
        return label
    }()
    let changeSortImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.sort
        return imageView
    }()
    let gapView: UIView = {
        let view = UIView()
        return view
    }()
    let gapLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T7_12_read
        label.textColor = ColorManager.gray_50
        return label
    }()
    let gapSortImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.sort
        return imageView
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
        
        coinView.addSubview(coinLabel)
        
        [priceSortImageView,priceLabel]
            .forEach {
                priceView.addSubview($0)
            }
        
        [changeSortImageView,changeLabel]
            .forEach {
                changeView.addSubview($0)
            }
        
        [gapSortImageView,gapLabel]
            .forEach {
                gapView.addSubview($0)
            }
        
        coinView.snp.makeConstraints { make in
            make.width.equalTo(121*Constants.standardWidth)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        coinLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        priceView.snp.makeConstraints { make in
            make.width.equalTo(90*Constants.standardWidth)
            make.leading.equalTo(coinView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        priceSortImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*Constants.standardHeight)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(priceSortImageView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        changeView.snp.makeConstraints { make in
            make.width.equalTo(68*Constants.standardWidth)
            make.leading.equalTo(priceView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        changeSortImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*Constants.standardHeight)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        changeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(changeSortImageView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        gapView.snp.makeConstraints { make in
            make.width.equalTo(56*Constants.standardWidth).priority(.low)
            make.leading.equalTo(priceView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        gapSortImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*Constants.standardHeight)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        gapLabel.snp.makeConstraints { make in
            make.trailing.equalTo(gapSortImageView.snp.leading).priority(.low)
            make.centerY.equalToSuperview()
        }
    }
}
