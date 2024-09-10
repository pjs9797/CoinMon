import UIKit
import SnapKit

class DetailCoinInfoView: UIView {
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    let coinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D5_18
        label.textColor = ColorManager.common_0
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D1_28
        label.textColor = ColorManager.common_0
        return label
    }()
    let comparePriceLabel: UILabel = {
        let label = UILabel()
        label.text = "어제대비 +1,580,475원(2.07%)"
        label.font = FontManager.B4_15
        label.textColor = ColorManager.red_50
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
        [coinImageView,coinTitleLabel,priceLabel,comparePriceLabel]
            .forEach{
                addSubview($0)
            }
        
        coinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(19*ConstantsManager.standardHeight)
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(26*ConstantsManager.standardHeight)
            make.leading.equalTo(coinImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.height.equalTo(36*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(coinImageView.snp.bottom).offset(5*ConstantsManager.standardHeight)
        }
        
        comparePriceLabel.snp.makeConstraints { make in
            make.height.equalTo(23*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardHeight)
            make.top.equalTo(priceLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
    }
}
