import UIKit
import SnapKit

class PremiumView: UIView {
    let departureMarketButton: PremiumMarketButton = {
        let button = PremiumMarketButton(leftImage: ImageManager.upbit, rightImage: ImageManager.chevron_Down)
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "업비트"), for: .normal)
        button.titleLabel?.font = FontManager.H6_14
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.layer.cornerRadius = 8 * ConstantsManager.standardHeight
        button.backgroundColor = ColorManager.gray_22
        return button
    }()
    let leftRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.arrow_Left_Right
        return imageView
    }()
    let arrivalMarketButton: PremiumMarketButton = {
        let button = PremiumMarketButton(leftImage: ImageManager.binance, rightImage: ImageManager.chevron_Down)
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "바이낸스"), for: .normal)
        button.titleLabel?.font = FontManager.H6_14
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.layer.cornerRadius = 8 * ConstantsManager.standardHeight
        button.backgroundColor = ColorManager.gray_22
        return button
    }()
    let premiumTableViewHeader = PremiumTableViewHeader()
    let premiumTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = ColorManager.common_100
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = ColorManager.gray_99
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 52 * ConstantsManager.standardHeight
        tableView.register(FeePremiumTableViewCell.self, forCellReuseIdentifier: "FeePremiumTableViewCell")
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        departureMarketButton.setTitle(LocalizationManager.shared.localizedString(forKey: "Upbit"), for: .normal)
        arrivalMarketButton.setTitle(LocalizationManager.shared.localizedString(forKey: "Binance"), for: .normal)
        premiumTableViewHeader.coinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "코인"), for: .normal)
        premiumTableViewHeader.premiumButton.setTitle(LocalizationManager.shared.localizedString(forKey: "김프"), for: .normal)
    }
    
    private func layout() {
        [leftRightImageView, departureMarketButton, arrivalMarketButton, premiumTableViewHeader, premiumTableView]
            .forEach {
                addSubview($0)
            }
        
        leftRightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24 * ConstantsManager.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(13 * ConstantsManager.standardHeight)
        }

        departureMarketButton.snp.makeConstraints { make in
            make.trailing.equalTo(leftRightImageView.snp.leading).offset(-8 * ConstantsManager.standardWidth)
            make.centerY.equalTo(leftRightImageView)
        }

        arrivalMarketButton.snp.makeConstraints { make in
            make.leading.equalTo(leftRightImageView.snp.trailing).offset(8 * ConstantsManager.standardWidth)
            make.centerY.equalTo(leftRightImageView)
        }
        
        premiumTableViewHeader.snp.makeConstraints { make in
            make.height.equalTo(32*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(leftRightImageView.snp.bottom).offset(13 * ConstantsManager.standardHeight)
        }

        premiumTableView.snp.makeConstraints { make in
            make.top.equalTo(premiumTableViewHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
