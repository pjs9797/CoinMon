import UIKit
import RxSwift
import SnapKit

class IndicatorHistoryTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func layout(){
        [alertTimeLabel,alertTypeLabel,alertPriceLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        alertTimeLabel.snp.makeConstraints { make in
            make.width.equalTo(100*ConstantsManager.standardWidth)
            make.leading.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20*ConstantsManager.standardHeight)
        }
        
        alertTypeLabel.snp.makeConstraints { make in
            make.width.equalTo(57*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(alertTimeLabel)
        }
        
        alertPriceLabel.snp.makeConstraints { make in
            make.leading.equalTo(alertTimeLabel.snp.trailing).offset(16*ConstantsManager.standardWidth)
            make.trailing.equalTo(alertTypeLabel.snp.leading).offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(alertTimeLabel)
        }
    }
    
    func configure(with indicatorCoinHistories: IndicatorCoinHistory) {
        alertTimeLabel.text = formatDateString(indicatorCoinHistories.time)
        alertPriceLabel.text = "$\(indicatorCoinHistories.price)"
        alertTypeLabel.text = LocalizationManager.shared.localizedString(forKey: indicatorCoinHistories.timing)
        if indicatorCoinHistories.timing == "매수" {
            alertTimeLabel.textColor = ColorManager.green_40
            alertPriceLabel.textColor = ColorManager.green_40
            alertTypeLabel.textColor = ColorManager.green_40
        }
        else {
            alertTimeLabel.textColor = ColorManager.red_50
            alertPriceLabel.textColor = ColorManager.red_50
            alertTypeLabel.textColor = ColorManager.red_50
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
