import UIKit
import RxSwift
import SnapKit

class NotificationTypeCollectionViewCell: UICollectionViewCell {
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.H6_14
        label.textColor = ColorManager.gray_60
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 8*ConstantsManager.standardHeight
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.backgroundColor = ColorManager.gray_99
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateUI()
    }
    
    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        typeLabel.textColor = isSelected ? ColorManager.common_100 : ColorManager.gray_60
        self.backgroundColor = isSelected ? ColorManager.gray_22 : ColorManager.gray_99
    }
    
    private func layout(){
        contentView.addSubview(typeLabel)
        
        typeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(6)
        }
    }
    
    func configure(with type: String) {
        typeLabel.text = type
    }
}
