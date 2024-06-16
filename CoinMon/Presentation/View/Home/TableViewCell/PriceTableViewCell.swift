import UIKit
import SnapKit

class PriceTableViewCell: UITableViewCell {
    let coinView: UIView = {
        let view = UIView()
        return view
    }()
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12*Constants.standardHeight
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
    let gapView: UIView = {
        let view = UIView()
        return view
    }()
    let gapLabel: UILabel = {
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
            make.width.equalTo(121*Constants.standardWidth)
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
        }

        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        coinLabel.snp.makeConstraints { make in
            make.height.equalTo(42*Constants.standardHeight)
            make.leading.equalTo(coinImageView.snp.trailing).offset(6*Constants.standardWidth)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        priceView.snp.makeConstraints { make in
            make.width.equalTo(90*Constants.standardWidth)
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalTo(coinView.snp.trailing)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        changeView.snp.makeConstraints { make in
            make.width.equalTo(68*Constants.standardWidth)
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalTo(priceView.snp.trailing)
        }

        changeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        gapView.snp.makeConstraints { make in
            make.height.equalTo(52*Constants.standardHeight)
            make.leading.equalTo(changeView.snp.trailing)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
        }

        gapLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-4*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with priceList: CoinPrice) {
        coinImageView.image = UIImage(named: priceList.coinTitle) ?? ImageManager.login_coinmon
        coinLabel.text = priceList.coinTitle
        priceLabel.text = priceList.price
        changeLabel.text = priceList.change
        gapLabel.text = priceList.gap
        if priceList.change.first == "-" {
            changeLabel.textColor = .blue
        }
        else if priceList.change == "0.00%" {
            changeLabel.textColor = .black
        }
        else {
            changeLabel.textColor = .red
        }
        if priceList.change == "-" {
            changeLabel.textAlignment = .center
        }
        if priceList.gap == "-" {
            gapLabel.textAlignment = .center
        }
    }
}
