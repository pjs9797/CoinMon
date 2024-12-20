import UIKit
import SnapKit
import Kingfisher

class PriceTableViewCell: UITableViewCell {
    let coinView: UIView = {
        let view = UIView()
        return view
    }()
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return imageView
    }()
    let coinLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D9_13
        label.textColor = ColorManager.common_0
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    let priceView: UIView = {
        let view = UIView()
        return view
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H7_13
        label.textColor = ColorManager.common_0
        label.textAlignment = .right
        return label
    }()
    let changeView: UIView = {
        let view = UIView()
        return view
    }()
    let changeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H7_13
        label.textColor = ColorManager.common_0
        label.textAlignment = .right
        return label
    }()
    let gapView: UIView = {
        let view = UIView()
        return view
    }()
    let gapLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H7_13
        label.textColor = ColorManager.common_0
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.backgroundColor = ColorManager.common_100
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
        
        [coinImageView,coinLabel]
            .forEach {
                coinView.addSubview($0)
            }
        
        priceView.addSubview(priceLabel)
        changeView.addSubview(changeLabel)
        gapView.addSubview(gapLabel)
        
        coinView.snp.makeConstraints { make in
            make.width.equalTo(121*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
        }

        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        coinLabel.snp.makeConstraints { make in
            make.height.equalTo(42*ConstantsManager.standardHeight)
            make.leading.equalTo(coinImageView.snp.trailing).offset(6*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        priceView.snp.makeConstraints { make in
            make.width.equalTo(90*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalTo(coinView.snp.trailing)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        changeView.snp.makeConstraints { make in
            make.width.equalTo(68*ConstantsManager.standardWidth)
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalTo(priceView.snp.trailing)
        }

        changeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        gapView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalTo(changeView.snp.trailing)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
        }

        gapLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with priceList: CoinPriceChangeGap) {
        let baseURL = "http://\(ConfigManager.serverBaseURL)/images/"
        if let imageURL = URL(string: "\(baseURL)\(priceList.coinTitle).png") {
            coinImageView.kf.setImage(with: imageURL, placeholder: ImageManager.login_coinmon)
        } else {
            coinImageView.image = ImageManager.login_coinmon
        }
        coinLabel.text = priceList.coinTitle
        if let formattedPrice = formatPrice(priceList.price) {
            priceLabel.text = formattedPrice
        }
        else {
            priceLabel.text = priceList.price
        }
        changeLabel.text = "\(priceList.change)%"
        gapLabel.text = "\(priceList.gap)%"
        if priceList.change == "-99.00" {
            changeLabel.text = "-"
            changeLabel.textAlignment = .center
        }
        else {
            changeLabel.textAlignment = .right
        }
        if priceList.gap == "-99.00" {
            gapLabel.text = "-"
            gapLabel.textAlignment = .center
        }
        else {
            gapLabel.textAlignment = .right
        }
        if priceList.change.first == "-" && priceList.change.count > 1 {
            changeLabel.textColor = ColorManager.blue_50
        }
        else if priceList.change == "0.00" {
            changeLabel.textColor = ColorManager.common_0
        }
        else {
            changeLabel.textColor = ColorManager.red_50
        }
    }
    
    private func formatPrice(_ price: String) -> String? {
        guard let number = Double(price) else { return nil }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        return formatter.string(from: NSNumber(value: number))
    }
}
