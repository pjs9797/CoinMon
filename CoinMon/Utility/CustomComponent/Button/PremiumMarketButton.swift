import UIKit
import SnapKit

class PremiumMarketButton: UIButton {
    let leftImageView = UIImageView()
    private let rightImageView = UIImageView()

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
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        rightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }

        titleLabel?.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(2)
            make.trailing.equalTo(rightImageView.snp.leading).offset(-2)
            make.centerY.equalToSuperview()
        }

        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.lineBreakMode = .byTruncatingTail
    }

    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel?.intrinsicContentSize ?? .zero
        let width = 8 + 20 + 2 + titleSize.width + 2 + 20 + 8
        let height = max(35, titleSize.height + 16)
        return CGSize(width: width, height: height)
    }
}
