import UIKit
import SnapKit

class ButtonToastMessageView: UIView {
    let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.circle_Check_Green
        return imageView
    }()
    let toastLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T3_16
        label.textColor = ColorManager.common_100
        return label
    }()
    let toastButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.common_100, for: .normal)
        button.titleLabel?.font = FontManager.T5_14
        return button
    }()
    
    init(message: String, buttonTitle: String) {
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 8*ConstantsManager.standardHeight
        self.backgroundColor = ColorManager.gray_10
        toastLabel.text = message
        toastButton.setTitle(buttonTitle, for: .normal)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [checkImageView,toastLabel,toastButton]
            .forEach{
                addSubview($0)
            }
        
        checkImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        toastLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        toastButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
    }
}
