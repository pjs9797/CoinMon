import UIKit
import SnapKit

class DetailIndicatorCoinView: UIView {
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
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
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "바이낸스 이동"), attributes: .init([.font: FontManager.D6_16]))
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14)
        configuration.baseForegroundColor = ColorManager.common_100
        configuration.baseBackgroundColor = ColorManager.orange_60
        
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 8 * ConstantsManager.standardHeight
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [coinImageView,coinTitleLabel,coinPriceLabel,goToBinanceButton]
            .forEach{
                addSubview($0)
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
            make.bottom.equalToSuperview().offset(-8*ConstantsManager.standardHeight)
        }
        
        goToBinanceButton.snp.makeConstraints { make in
            make.height.equalTo(40*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(coinTitleLabel.snp.top)
        }
    }
}
