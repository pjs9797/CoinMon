import UIKit
import SnapKit

class InquiryButton: UIButton {
    let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.arrow_Right
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
        addSubview(rightImageView)

        rightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
