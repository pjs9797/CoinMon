import UIKit
import SnapKit

class SelectCoinTableViewCell: UITableViewCell {
    let coinView: UIView = {
        let view = UIView()
        return view
    }()
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12*ConstantsManager.standardHeight
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = ColorManager.gray_99?.cgColor
        return imageView
    }()
    let coinLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D9_13
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
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout(){
        [coinView,priceView]
            .forEach {
                contentView.addSubview($0)
            }
        
        [coinImageView,coinLabel]
            .forEach {
                coinView.addSubview($0)
            }
        
        priceView.addSubview(priceLabel)
        
        coinView.snp.makeConstraints { make in
            make.width.equalTo(170*ConstantsManager.standardWidth)
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
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalTo(coinView.snp.trailing)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    func configurePrice(with coinPriceAtAlarm: CoinPrice) {
        coinImageView.image = UIImage(named: coinPriceAtAlarm.coinTitle) ?? ImageManager.login_coinmon
        coinLabel.text = coinPriceAtAlarm.coinTitle
        priceLabel.text = coinPriceAtAlarm.price
        if let formattedPrice = formatPrice(coinPriceAtAlarm.price) {
            priceLabel.text = formattedPrice
        } 
        else {
            priceLabel.text = coinPriceAtAlarm.price
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
