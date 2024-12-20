import UIKit
import SnapKit
import Kingfisher

class FeePremiumTableViewCell: UITableViewCell {
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
    let feePremiumView: UIView = {
        let view = UIView()
        return view
    }()
    let feePremiumLabel: UILabel = {
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
        [coinView,feePremiumView]
            .forEach {
                contentView.addSubview($0)
            }
        
        [coinImageView,coinLabel]
            .forEach {
                coinView.addSubview($0)
            }
        
        feePremiumView.addSubview(feePremiumLabel)
        
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
        
        feePremiumView.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalTo(coinView.snp.trailing)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
        }

        feePremiumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureFee(with feeList: CoinFee) {
        let baseURL = "http://\(ConfigManager.serverBaseURL)/images/"
        if let imageURL = URL(string: "\(baseURL)\(feeList.coinTitle).png") {
            coinImageView.kf.setImage(with: imageURL, placeholder: ImageManager.login_coinmon)
        } else {
            coinImageView.image = ImageManager.login_coinmon
        }
        coinLabel.text = feeList.coinTitle
        feePremiumLabel.text = "\(feeList.fee)%"
        if feeList.fee.first == "-" {
            feePremiumLabel.textColor = ColorManager.blue_50
        }
        else if feeList.fee == "0" {
            feePremiumLabel.textColor = ColorManager.common_0
        }
        else {
            feePremiumLabel.textColor = ColorManager.red_50
        }
    }
    
    func configurePremium(with premiumList: CoinPremium) {
        coinImageView.image = UIImage(named: premiumList.coinTitle) ?? ImageManager.login_coinmon
        coinLabel.text = premiumList.coinTitle
        feePremiumLabel.text = "\(premiumList.premium)%"
        if premiumList.premium.first == "-" {
            feePremiumLabel.textColor = ColorManager.blue_50
        }
        else if premiumList.premium == "0.00" {
            feePremiumLabel.textColor = ColorManager.common_0
        }
        else {
            feePremiumLabel.textColor = ColorManager.red_50
        }
    }
}
