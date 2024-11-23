import UIKit
import SnapKit
import Kingfisher

class DetailIndicatorCoinView: UIView {
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.login_coinmon
        return imageView
    }()
    let coinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let coinPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.common_0
        return label
    }()
    let goToBinanceButton: UIButton = {
        let button = ConfigurationButton(font: FontManager.D6_16, foregroundColor: ColorManager.common_100, backgroundColor: ColorManager.orange_60)
        var configuration = button.configuration
        configuration?.title = LocalizationManager.shared.localizedString(forKey: "바이낸스 이동")
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8*ConstantsManager.standardHeight, leading: 14*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, trailing: 14*ConstantsManager.standardWidth)
        button.configuration = configuration
        button.layer.cornerRadius = 8 * ConstantsManager.standardHeight
        return button
    }()
    let alertView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.common_100
        view.layer.cornerRadius = 8*ConstantsManager.standardHeight
        view.layer.borderColor = ColorManager.gray_96?.cgColor
        view.layer.borderWidth = 1
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [coinImageView,coinTitleLabel,coinPriceLabel,goToBinanceButton,alertView]
            .forEach{
                addSubview($0)
            }
        
        [alertTimeLabel,alertTypeLabel,alertPriceLabel]
            .forEach {
                alertView.addSubview($0)
            }
        
        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(18*ConstantsManager.standardHeight)
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalTo(coinImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        coinPriceLabel.snp.makeConstraints { make in
            make.height.equalTo(22*ConstantsManager.standardHeight)
            make.leading.equalTo(coinTitleLabel.snp.leading)
            make.top.equalTo(coinTitleLabel.snp.bottom)
        }
        
        goToBinanceButton.snp.makeConstraints { make in
            make.height.equalTo(40*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(coinTitleLabel.snp.top)
        }
        
        alertView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(coinPriceLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
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
    
    func isEmptyHistory() {
        alertView.isHidden = true
        
        coinPriceLabel.snp.remakeConstraints { make in
            make.height.equalTo(22*ConstantsManager.standardHeight)
            make.leading.equalTo(coinTitleLabel.snp.leading)
            make.top.equalTo(coinTitleLabel.snp.bottom)
            make.bottom.equalToSuperview().offset(-8*ConstantsManager.standardHeight)
        }
    }
    
    func isNotEmptyHistory(indicatorCoinHistory: IndicatorCoinHistory) {
        alertTimeLabel.text = formatDateString(indicatorCoinHistory.time)
        alertPriceLabel.text = "$\(indicatorCoinHistory.price)"
        alertTypeLabel.text = LocalizationManager.shared.localizedString(forKey: indicatorCoinHistory.timing)
        if indicatorCoinHistory.timing == "매수" {
            alertTimeLabel.textColor = ColorManager.green_40
            alertPriceLabel.textColor = ColorManager.green_40
            alertTypeLabel.textColor = ColorManager.green_40
        }
        else {
            alertTimeLabel.textColor = ColorManager.red_50
            alertPriceLabel.textColor = ColorManager.red_50
            alertTypeLabel.textColor = ColorManager.red_50
        }
        alertView.isHidden = false
        
        coinPriceLabel.snp.remakeConstraints { make in
            make.height.equalTo(22*ConstantsManager.standardHeight)
            make.leading.equalTo(coinTitleLabel.snp.leading)
            make.top.equalTo(coinTitleLabel.snp.bottom)
        }
        
        alertView.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(coinPriceLabel.snp.bottom).offset(8*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-8*ConstantsManager.standardHeight)
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
