import UIKit
import RxSwift
import SnapKit
import Kingfisher

class IndicatorAlarmTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let coinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D8_14
        label.textColor = ColorManager.gray_20
        return label
    }()
    let alarmButton: UIButton = {
        let button = ConfigurationButton(font: FontManager.D8_14, foregroundColor: ColorManager.gray_20, backgroundColor: ColorManager.common_100)
        var configuration = button.configuration
        configuration?.title = LocalizationManager.shared.localizedString(forKey: "알람 받기")
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 6*ConstantsManager.standardHeight, leading: 12*ConstantsManager.standardWidth, bottom: 6*ConstantsManager.standardHeight, trailing: 12*ConstantsManager.standardWidth)
        button.configuration = configuration
        button.layer.cornerRadius = 8*ConstantsManager.standardHeight
        button.layer.borderColor = ColorManager.gray_96?.cgColor
        button.layer.borderWidth = 1
        button.isEnabled = true
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
        [coinImageView,coinTitleLabel,alarmButton]
            .forEach {
                contentView.addSubview($0)
            }
        
        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight).priority(.high)
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(15*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-15*ConstantsManager.standardHeight)
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(coinImageView)
        }
    }
    
    func configure(title: String) {
        coinTitleLabel.text = title
        let baseURL = "http://\(ConfigManager.serverBaseURL)/images/"
        if let imageURL = URL(string: "\(baseURL)\(title).png") {
            coinImageView.kf.setImage(with: imageURL, placeholder: ImageManager.login_coinmon)
        } else {
            coinImageView.image = ImageManager.login_coinmon
        }
    }
}
