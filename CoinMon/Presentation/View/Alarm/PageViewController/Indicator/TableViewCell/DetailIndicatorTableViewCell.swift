import UIKit
import RxSwift
import SnapKit

class DetailIndicatorTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.login_coinmon
        return imageView
    }()
    let coinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D8_14
        label.textColor = ColorManager.common_0
        return label
    }()
    let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.icon_Pin_fill?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorManager.gray_50
        return imageView
    }()
    let coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D8_14
        label.textColor = ColorManager.common_0
        label.textAlignment = .right
        return label
    }()
    let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.arrow_Right, for: .normal)
        return button
    }()
    let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    let alertTimeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_40
        return label
    }()
    let alertPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D9_13
        label.textColor = ColorManager.green_40
        label.textAlignment = .right
        return label
    }()
    let alertTypeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D8_14
        label.textColor = ColorManager.green_40
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func layout(){
        [coinImageView,coinTitleLabel,pinImageView,rightButton,coinPriceLabel,alertView,alertTimeLabel,alertPriceLabel,alertTypeLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        [alertTimeLabel,alertTypeLabel,alertPriceLabel]
            .forEach {
                alertView.addSubview($0)
            }
        
        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(14*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-40*ConstantsManager.standardHeight)
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        pinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalTo(coinTitleLabel.snp.trailing).offset(2*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        rightButton.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(coinImageView)
        }
        
        coinPriceLabel.snp.makeConstraints { make in
            make.width.equalTo(108*ConstantsManager.standardWidth)
            make.trailing.equalTo(rightButton.snp.leading).offset(-8*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        alertView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(coinImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        alertTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(95*ConstantsManager.standardWidth)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(10*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-10*ConstantsManager.standardHeight)
        }
        
        alertTypeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        alertPriceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(alertTypeLabel.snp.leading).offset(-8*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with indicatordata: IndicatorCoinData) {
        if indicatordata.timing == "매수" {
            alertTimeLabel.textColor = ColorManager.green_40
            alertPriceLabel.textColor = ColorManager.green_40
            alertTypeLabel.textColor = ColorManager.green_40
        }
        else {
            alertTimeLabel.textColor = ColorManager.red_50
            alertPriceLabel.textColor = ColorManager.red_50
            alertTypeLabel.textColor = ColorManager.red_50
        }
        coinTitleLabel.text = indicatordata.coinName
        coinPriceLabel.text = "$\(indicatordata.curPrice)"
        alertView.isHidden = true
        
        coinImageView.snp.remakeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight).priority(.high)
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(14*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-40*ConstantsManager.standardHeight)
        }
        
        if let recentTime = indicatordata.recentTime, let recentPrice = indicatordata.recentPrice, let timing = indicatordata.timing {
            alertView.isHidden = false
            alertTimeLabel.text = formatDateString(recentTime)
            alertPriceLabel.text = "$\(recentPrice)"
            alertTypeLabel.text = LocalizationManager.shared.localizedString(forKey: timing)
            
            coinImageView.snp.remakeConstraints { make in
                make.width.height.equalTo(20*ConstantsManager.standardHeight).priority(.high)
                make.leading.equalToSuperview()
                make.top.equalToSuperview().offset(14*ConstantsManager.standardHeight)
            }
            
            alertView.snp.remakeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalTo(coinImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
                make.bottom.equalToSuperview().offset(-24*ConstantsManager.standardHeight)
            }
        }
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = "MM.dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
