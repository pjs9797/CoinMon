import UIKit
import SnapKit

class PremiumView: UIView {
    let departureExchangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("업비트", for: .normal)
        button.titleLabel?.font = FontManager.H6_14
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.setImage(ImageManager.upbit, for: .normal)
        button.layer.cornerRadius = 8*Constants.standardHeight
        button.backgroundColor = ColorManager.gray_22
        let rightImageView = UIImageView(image: ImageManager.chevron_Down)
        button.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        return button
    }()
    let leftRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.arrow_Left_Right
        return imageView
    }()
    let arrivalExchangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("바이낸스", for: .normal)
        button.titleLabel?.font = FontManager.H6_14
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.setImage(ImageManager.binance, for: .normal)
        button.layer.cornerRadius = 8*Constants.standardHeight
        button.backgroundColor = ColorManager.gray_22
        let rightImageView = UIImageView(image: ImageManager.chevron_Down)
        button.addSubview(rightImageView)
        rightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        return button
    }()
    let premiumTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = 0
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = 52*Constants.standardHeight
        tableView.register(PremiumTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "PremiumTableViewHeader")
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
    
    private func layout() {
        [leftRightImageView,departureExchangeButton,arrivalExchangeButton,premiumTableView]
            .forEach{
                addSubview($0)
            }
        
        leftRightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(13*Constants.standardHeight)
        }
        
        departureExchangeButton.snp.makeConstraints { make in
            make.width.equalTo(100*Constants.standardWidth)
            make.height.equalTo(35*Constants.standardHeight)
            make.trailing.equalTo(leftRightImageView.snp.leading).offset(-8*Constants.standardWidth)
            make.centerY.equalTo(leftRightImageView)
        }
        
        arrivalExchangeButton.snp.makeConstraints { make in
            make.width.equalTo(100*Constants.standardWidth)
            make.height.equalTo(35*Constants.standardHeight)
            make.leading.equalTo(leftRightImageView.snp.trailing).offset(8*Constants.standardWidth)
            make.centerY.equalTo(leftRightImageView)
        }
        
        premiumTableView.snp.makeConstraints { make in
            make.top.equalTo(leftRightImageView.snp.bottom).offset(13*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
