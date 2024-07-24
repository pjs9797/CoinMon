import UIKit
import SnapKit

class NotificationTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.common_0
        label.font = FontManager.D7_15
        return label
    }()
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.gray_20
        label.font = FontManager.B5_14
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.gray_60
        label.font = FontManager.B7_12
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
        [titleLabel,bodyLabel,dateLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(23*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.height.equalTo(22*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(bodyLabel.snp.bottom).offset(10*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
    }
    
    func configure(with notifications: NotificationAlert) {
        titleLabel.text = LocalizationManager.shared.localizedString(forKey: "가격 알림 타이틀", arguments: notifications.symbol)
        if notifications.market == "BYBIT" || notifications.market == "BINANCE" {
            bodyLabel.text = LocalizationManager.shared.localizedString(forKey: "가격 알림 바디 usdt", arguments: notifications.market, notifications.symbol, notifications.targetPrice)
        }
        else {
            bodyLabel.text = LocalizationManager.shared.localizedString(forKey: "가격 알림 바디 krw", arguments: notifications.market, notifications.symbol, notifications.targetPrice)
        }
        if notifications.dateType == "일" {
            dateLabel.text = LocalizationManager.shared.localizedString(forKey: "가격 알림 타임 일", arguments: notifications.date)
        }
        else if notifications.dateType == "시간" {
            dateLabel.text = LocalizationManager.shared.localizedString(forKey: "가격 알림 타임 시간", arguments: notifications.date)
        }
        else {
            dateLabel.text = LocalizationManager.shared.localizedString(forKey: "가격 알림 타임 분", arguments: notifications.date)
        }
    }
}
