import UIKit
import RxSwift
import SnapKit
import Kingfisher

class SelectedCoinForIndicatorCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.login_coinmon
        return imageView
    }()
    let coinLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H7_13
        label.textColor = ColorManager.gray_30
        return label
    }()
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_close14, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 14*ConstantsManager.standardHeight
        self.layer.borderColor = ColorManager.gray_96?.cgColor
        self.layer.borderWidth = 1
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
        [coinImageView,coinLabel,deleteButton]
            .forEach{
                contentView.addSubview($0)
            }
        
        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(8*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(8 * ConstantsManager.standardHeight).priority(.medium)
            make.bottom.equalToSuperview().offset(-8 * ConstantsManager.standardHeight).priority(.medium)
            make.centerY.equalToSuperview()
        }
        
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinImageView.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-4*ConstantsManager.standardWidth).priority(.low)
            make.centerY.equalTo(coinImageView)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(14*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-10*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
    }
    
    func configure(with coin: String) {
        coinLabel.text = coin
        let baseURL = "http://\(ConfigManager.serverBaseURL)/images/"
        if let imageURL = URL(string: "\(baseURL)\(coin).png") {
            coinImageView.kf.setImage(with: imageURL, placeholder: ImageManager.login_coinmon)
        } else {
            coinImageView.image = ImageManager.login_coinmon
        }
    }
}
