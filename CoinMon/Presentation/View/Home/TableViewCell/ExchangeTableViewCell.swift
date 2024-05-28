import UIKit
import SnapKit

class ExchangeTableViewCell: UITableViewCell {
    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let coinLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D6_16
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout(){
        [coinImageView,coinLabel]
            .forEach {
                contentView.addSubview($0)
            }
        
        coinImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        coinLabel.snp.makeConstraints { make in
            make.leading.equalTo(coinImageView.snp.trailing).offset(8*Constants.standardWidth)
            make.centerY.equalTo(coinImageView)
        }
    }
}
