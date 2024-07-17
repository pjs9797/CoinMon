import UIKit
import SnapKit

class LanguageSettingButton: UIButton {
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.global
        return imageView
    }()
    let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.arrow_Down
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(leftImageView)
        addSubview(rightImageView)

        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(12*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        rightImageView.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(12*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        titleLabel?.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.trailing.equalTo(rightImageView.snp.leading).offset(-6*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
    }

    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel?.intrinsicContentSize ?? .zero
        let width = (12 + 4 + titleSize.width + 6 + 12)//*ConstantsManager.standardWidth
        let height = 38.0//*ConstantsManager.standardHeight
        return CGSize(width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = titleLabel?.frame.width ?? 0
    }
}
