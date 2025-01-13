import UIKit
import SnapKit

class LanguageSettingButton: UIButton {
    let tapGesture = UITapGestureRecognizer()
    let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.global
        return imageView
    }()
    let languageLabel: BaseLabel = {
        let label = BaseLabel()
        label.setStyle(text: "한국어", fontStyle: FontManagerA.T5_14, textColor: ColorManager.gray_60)
        return label
    }()
    let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.arrow_Down
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        self.addGestureRecognizer(tapGesture)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        [leftImageView,languageLabel,rightImageView]
            .forEach{
                addSubview($0)
            }

        leftImageView.snp.makeConstraints { make in
            make.width.height.equalTo(12*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(12*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(13*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-13*ConstantsManager.standardHeight)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftImageView.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalTo(leftImageView)
        }

        rightImageView.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(12*ConstantsManager.standardHeight)
            make.leading.equalTo(languageLabel.snp.trailing).offset(6*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-13*ConstantsManager.standardWidth)
            make.centerY.equalTo(leftImageView)
        }
    }
}
