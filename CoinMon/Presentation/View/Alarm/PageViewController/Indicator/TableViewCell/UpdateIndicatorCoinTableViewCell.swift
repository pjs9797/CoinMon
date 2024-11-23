import UIKit
import RxSwift
import SnapKit
import Kingfisher

class UpdateIndicatorCoinTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let pinButton: UIButton = {
        let button = UIButton()
        let pinImage = ImageManager.icon_Pin_fill?.withRenderingMode(.alwaysTemplate)
        pinImage?.withTintColor(ColorManager.gray_90 ?? .gray)
        button.setImage(pinImage, for: .normal)
        return button
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
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.iconClear, for: .normal)
        return button
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
        [pinButton,coinImageView,coinTitleLabel,deleteButton]
            .forEach {
                contentView.addSubview($0)
            }
        
        pinButton.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight).priority(.high)
            make.leading.equalToSuperview().offset(8*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(14*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-14*ConstantsManager.standardHeight)
        }
        
        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalTo(pinButton.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(pinButton)
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(200*ConstantsManager.standardWidth)
            make.leading.equalTo(coinImageView.snp.trailing).offset(8*ConstantsManager.standardHeight)
            make.centerY.equalTo(pinButton)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-8*ConstantsManager.standardWidth)
            make.centerY.equalTo(pinButton)
        }
    }
    
    func configure(with updateIndicatorCoinData: UpdateSelectedIndicatorCoin) {
        let baseURL = "http://\(ConfigManager.serverBaseURL)/images/"
        if let imageURL = URL(string: "\(baseURL)\(updateIndicatorCoinData.coinTitle).png") {
            coinImageView.kf.setImage(with: imageURL, placeholder: ImageManager.login_coinmon)
        } else {
            coinImageView.image = ImageManager.login_coinmon
        }
        coinTitleLabel.text = updateIndicatorCoinData.coinTitle
        let tintColor = updateIndicatorCoinData.isPinned ? ColorManager.gray_20 : ColorManager.gray_90
        pinButton.tintColor = tintColor
    }
}
