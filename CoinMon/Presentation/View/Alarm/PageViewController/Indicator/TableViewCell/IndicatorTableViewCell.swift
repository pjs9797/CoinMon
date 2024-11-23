import UIKit
import RxSwift
import SnapKit
import Kingfisher

class IndicatorTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let indicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.backgroundColor = ColorManager.common_100
        return view
    }()
    let indicatorTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.D6_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let explainButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_questionMark18, for: .normal)
        return button
    }()
    let premiumLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium"
        label.textColor = ColorManager.gray_40
        label.font = FontManager.D8_14
        return label
    }()
    let alarmSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.onTintColor = ColorManager.orange_60
        uiSwitch.tintColor = ColorManager.gray_90
        uiSwitch.layer.cornerRadius = 16*ConstantsManager.standardHeight
        return uiSwitch
    }()
    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_20
        return label
    }()
    let separteView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        return view
    }()
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
        self.backgroundColor = ColorManager.gray_99
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
        contentView.addSubview(indicatorView)
        [alarmSwitch,indicatorTitleLabel,explainButton,premiumLabel,frequencyLabel,separteView,coinImageView,coinTitleLabel,rightButton,coinPriceLabel,alertView]
            .forEach {
                indicatorView.addSubview($0)
            }
        
        [alertTimeLabel,alertTypeLabel,alertPriceLabel]
            .forEach {
                alertView.addSubview($0)
            }
        
        indicatorView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.size.width - (40 * ConstantsManager.standardWidth)).priority(.high)
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12*ConstantsManager.standardHeight)
        }
        
        alarmSwitch.snp.makeConstraints { make in
            make.width.equalTo(50*ConstantsManager.standardWidth)
            make.height.equalTo(28*ConstantsManager.standardHeight)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
        }
        
        indicatorTitleLabel.snp.makeConstraints { make in
            //make.width.lessThanOrEqualTo(117*ConstantsManager.standardWidth)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        explainButton.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalTo(indicatorTitleLabel.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorTitleLabel.snp.top).offset(2*ConstantsManager.standardHeight)
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.leading.equalTo(explainButton.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.top.equalTo(explainButton)
        }
        
        frequencyLabel.snp.makeConstraints { make in
            make.height.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorTitleLabel.snp.bottom).offset(3*ConstantsManager.standardHeight)
        }
        
        separteView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(frequencyLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(separteView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(139*ConstantsManager.standardWidth)
            make.leading.equalTo(coinImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        rightButton.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        coinPriceLabel.snp.makeConstraints { make in
            make.width.equalTo(102*ConstantsManager.standardWidth)
            make.trailing.equalTo(rightButton.snp.leading).offset(-8*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        alertView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
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
        
        let baseURL = "http://\(ConfigManager.serverBaseURL)/images/"
        if let imageURL = URL(string: "\(baseURL)\(indicatordata.coinName).png") {
            coinImageView.kf.setImage(with: imageURL, placeholder: ImageManager.login_coinmon)
        } else {
            coinImageView.image = ImageManager.login_coinmon
        }
        
        premiumLabel.isHidden = indicatordata.isPremium == "Y" ? false : true
        alarmSwitch.isOn = indicatordata.isOn == "Y" ? true : false
        coinTitleLabel.text = indicatordata.coinName
        coinPriceLabel.text = "$\(indicatordata.curPrice)"
        alertView.isHidden = true
        
        coinImageView.snp.remakeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(separteView.snp.bottom).offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-18*ConstantsManager.standardHeight)
        }
        
        if let recentTime = indicatordata.recentTime, let recentPrice = indicatordata.recentPrice, let timing = indicatordata.timing {
            alertView.isHidden = false
            alertTimeLabel.text = formatDateString(recentTime)
            alertPriceLabel.text = "$\(recentPrice)"
            alertTypeLabel.text = LocalizationManager.shared.localizedString(forKey: timing)
            
            coinImageView.snp.remakeConstraints { make in
                make.width.height.equalTo(20*ConstantsManager.standardHeight)
                make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
                make.top.equalTo(separteView.snp.bottom).offset(16*ConstantsManager.standardHeight)
            }
            
            alertView.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
                make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
                make.top.equalTo(coinImageView.snp.bottom).offset(16*ConstantsManager.standardHeight)
                make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight).priority(.low)
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
