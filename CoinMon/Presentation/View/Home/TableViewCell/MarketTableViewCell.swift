import UIKit
import SnapKit
import RxSwift

class MarketTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let marketImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let marketLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textAlignment = .left
        return label
    }()
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.check_Orange
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    private func layout(){
        [marketImageView,marketLabel,checkImageView]
            .forEach {
                contentView.addSubview($0)
            }
        
        marketImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        marketLabel.snp.makeConstraints { make in
            make.leading.equalTo(marketImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(marketImageView)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with market: Market, localizationKey: String) {
        marketImageView.image = UIImage(named: market.localizationKey)
        marketLabel.text = market.marketTitle
        if localizationKey != "" && market.localizationKey == localizationKey {
            checkImageView.isHidden = false
        }
    }
}
