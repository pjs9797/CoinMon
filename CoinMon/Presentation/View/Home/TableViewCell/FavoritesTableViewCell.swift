import UIKit
import SnapKit
import RxSwift

class FavoritesTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.circle_Check, for: .normal)
        return button
    }()
    
    let coinTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T4_15
        label.textColor = ColorManager.common_0
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.Handle24, for: .normal)
        button.isHidden = true
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
    
    var isChecked: Bool = false {
        didSet {
            updateCheckButtonImage()
        }
    }
    
    private func layout(){
        [checkButton, coinTitleLabel, editButton]
            .forEach {
                contentView.addSubview($0)
            }
        
        checkButton.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardHeight)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
        
        coinTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(12*ConstantsManager.standardWidth)
            make.centerY.equalTo(checkButton)
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.centerY.equalTo(checkButton)
        }
    }
    
    func configure(with coin: String, isFirst: Bool = false, isChecked: Bool = false) {
        coinTitleLabel.text = coin
        self.isChecked = isChecked
        if isFirst {
            coinTitleLabel.text = LocalizationManager.shared.localizedString(forKey: "전체")
        }
    }
    
    private func updateCheckButtonImage() {
        let image = isChecked ? ImageManager.circle_Check_Orange : ImageManager.circle_Check
        checkButton.setImage(image, for: .normal)
    }
}
