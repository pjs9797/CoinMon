import UIKit
import SnapKit

class AlarmTableViewCell: UITableViewCell {
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
    let setPriceView: UIView = {
        let view = UIView()
        return view
    }()
    let setPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D9_13
        label.textAlignment = .left
        return label
    }()
    let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T6_13
        label.textAlignment = .left
        return label
    }()
    let alarmSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.onTintColor = ColorManager.orange_60
        uiSwitch.tintColor = ColorManager.gray_90
        uiSwitch.layer.cornerRadius = 18*Constants.standardHeight
        return uiSwitch
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
        [coinView,setPriceView,alarmSwitch]
            .forEach {
                contentView.addSubview($0)
            }
        
        [coinImageView,coinLabel]
            .forEach {
                coinView.addSubview($0)
            }
        [setPriceLabel,currentPriceLabel]
            .forEach{
                setPriceView.addSubview($0)
            }
        
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
        
        setPriceView.snp.makeConstraints { make in
            make.width.equalTo(148*Constants.standardWidth)
            make.height.equalTo(36*Constants.standardHeight)
            make.leading.equalTo(coinView.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        setPriceLabel.snp.makeConstraints { make in
            make.width.equalTo(148*Constants.standardWidth)
            make.height.equalTo(18*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        currentPriceLabel.snp.makeConstraints { make in
            make.width.equalTo(148*Constants.standardWidth)
            make.height.equalTo(18*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(setPriceLabel.snp.bottom)
        }
        
        alarmSwitch.snp.makeConstraints { make in
            make.width.equalTo(50*Constants.standardWidth)
            make.height.equalTo(28*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with alarmList: AlarmList) {
        coinImageView.image = UIImage(named: alarmList.coinTitle)
        coinLabel.text = alarmList.coinTitle
        setPriceLabel.text = String(alarmList.setPrice)
        currentPriceLabel.text = String(alarmList.currentPrice)
        alarmSwitch.isOn = alarmList.isOn
    }
}
