import UIKit
import SnapKit
import RxSwift
import Kingfisher

class CoinForIndicatorTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let coinView: UIView = {
        let view = UIView()
        return view
    }()
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.login_coinmon
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
    let changeView: UIView = {
        let view = UIView()
        return view
    }()
    let changeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H7_13
        label.textAlignment = .right
        return label
    }()
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.circle_Check, for: .normal)
        return button
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
        [coinView,priceView,changeView,checkButton]
            .forEach {
                contentView.addSubview($0)
            }
        
        [coinImageView,coinLabel]
            .forEach {
                coinView.addSubview($0)
            }
        
        priceView.addSubview(priceLabel)
        changeView.addSubview(changeLabel)
        
        coinView.snp.makeConstraints { make in
            make.width.equalTo(125*ConstantsManager.standardWidth)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(8*ConstantsManager.standardWidth)
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
            make.leading.equalTo(coinView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        changeView.snp.makeConstraints { make in
            make.width.equalTo(82*ConstantsManager.standardWidth)
            make.leading.equalTo(priceView.snp.trailing)
            make.centerY.equalToSuperview()
        }

        changeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-6*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with list: IndicatorCoinPriceChange) {
        let baseURL = "http://\(ConfigManager.serverBaseURL)/images/"
        if let imageURL = URL(string: "\(baseURL)\(list.coinTitle).png") {
            coinImageView.kf.setImage(with: imageURL, placeholder: ImageManager.login_coinmon)
        } else {
            coinImageView.image = ImageManager.login_coinmon
        }
        coinLabel.text = list.coinTitle
        if let formattedPrice = formatPrice(list.price) {
            priceLabel.text = formattedPrice
        }
        else {
            priceLabel.text = list.price
        }
        changeLabel.text = "\(list.change)%"
        if list.change == "-99.00" {
            changeLabel.text = "-"
            changeLabel.textAlignment = .center
        }
        else {
            changeLabel.textAlignment = .right
        }
        if list.change.first == "-" && list.change.count > 1 {
            changeLabel.textColor = ColorManager.blue_50
        }
        else if list.change == "0.00" {
            changeLabel.textColor = ColorManager.common_0
        }
        else {
            changeLabel.textColor = ColorManager.red_50
        }
        
        checkButton.setImage(list.isChecked ? ImageManager.circle_Check_Orange : ImageManager.circle_Check, for: .normal)
    }
    
    private func formatPrice(_ price: String) -> String? {
        guard let number = Double(price) else { return nil }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        return formatter.string(from: NSNumber(value: number))
    }
}
