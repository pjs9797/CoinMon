import UIKit
import RxSwift
import SnapKit

class MarketListCollectionViewCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    let marketImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let marketLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.gray_60
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8*Constants.standardHeight
        self.backgroundColor = ColorManager.gray_99
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        updateUI()
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        marketLabel.textColor = isSelected ? ColorManager.common_100 : ColorManager.gray_60
        self.backgroundColor = isSelected ? ColorManager.gray_22 : ColorManager.gray_99
    }
    
    private func layout(){
        [marketImageView,marketLabel]
            .forEach{
                contentView.addSubview($0)
            }
        
        marketImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*Constants.standardHeight)
            make.leading.equalToSuperview().offset(8*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        marketLabel.snp.makeConstraints { make in
            make.leading.equalTo(marketImageView.snp.trailing).offset(2*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with market: Market) {
        marketImageView.image = UIImage(named: market.localizationKey)
        marketLabel.text = market.marketTitle
    }
}
