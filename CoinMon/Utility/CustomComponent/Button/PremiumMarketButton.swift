import UIKit
import SnapKit

class PremiumMarketButton: UIButton {
    let leftImageView = UIImageView()
    let rightImageView = UIImageView()

    init(leftImage: UIImage?, rightImage: UIImage?) {
        super.init(frame: .zero)
        leftImageView.image = leftImage
        rightImageView.image = rightImage
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(leftImageView)
        addSubview(rightImageView)

        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(8*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }

        rightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-8*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }

        titleLabel?.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(2*ConstantsManager.standardWidth)
            make.trailing.equalTo(rightImageView.snp.leading).offset(-2*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }

    }

    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel?.intrinsicContentSize ?? .zero
        let width = (8 + 20 + 2 + titleSize.width + 2 + 20 + 8)//*ConstantsManager.standardWidth
        let height = 35.0//*ConstantsManager.standardHeight
        return CGSize(width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = titleLabel?.frame.width ?? 0
    }
}
