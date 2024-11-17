import UIKit
import RxSwift
import SnapKit

class NotSubscriptionIndicatorTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let indicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.backgroundColor = ColorManager.common_100
        return view
    }()
    let indicatorTitleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.D6_16
        label.textColor = ColorManager.common_0
        return label
    }()
    let explainButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.icon_questionMark18, for: .normal)
        return button
    }()
    let premiumLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium"
        label.textColor = ColorManager.gray_40
        label.font = FontManager.D8_14
        return label
    }()
    let alarmSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.onTintColor = ColorManager.orange_60
        uiSwitch.tintColor = ColorManager.gray_90
        uiSwitch.layer.cornerRadius = 16*ConstantsManager.standardHeight
        uiSwitch.isEnabled = false
        return uiSwitch
    }()
    let frequencyLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T6_13
        label.textColor = ColorManager.gray_20
        return label
    }()
    let noticeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "기간이 종료됐어요"), attributes: .init([.font: FontManager.H6_14]))
        configuration.baseForegroundColor = ColorManager.orange_60
        configuration.baseBackgroundColor = ColorManager.common_100
        configuration.image = ImageManager.icon_attention24
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4*ConstantsManager.standardWidth
        let button = UIButton(configuration: configuration)
        button.isEnabled = false
        return button
    }()
    let subscribeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "프리미엄 구독하기"), attributes: .init([.font: FontManager.D8_14]))
        configuration.baseForegroundColor = ColorManager.common_100
        configuration.baseBackgroundColor = ColorManager.orange_60
        configuration.image = ImageManager.icon_attention24
        configuration.imagePlacement = .leading
        configuration.imagePadding = 4*ConstantsManager.standardWidth
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 8*ConstantsManager.standardHeight
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.backgroundColor = ColorManager.gray_99
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    private func layout(){
        contentView.addSubview(indicatorView)
        [alarmSwitch,indicatorTitleLabel,explainButton,premiumLabel,frequencyLabel,noticeButton,subscribeButton]
            .forEach {
                indicatorView.addSubview($0)
            }
        
        indicatorView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.size.width - (40 * ConstantsManager.standardWidth)).priority(.high)
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12*ConstantsManager.standardHeight)
        }
        
        alarmSwitch.snp.makeConstraints { make in
            make.width.equalTo(50*ConstantsManager.standardWidth)
            make.height.equalTo(28*ConstantsManager.standardHeight)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
        }
        
        indicatorTitleLabel.snp.makeConstraints { make in
            //make.width.lessThanOrEqualTo(117*ConstantsManager.standardWidth)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        explainButton.snp.makeConstraints { make in
            make.width.height.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalTo(indicatorTitleLabel.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorTitleLabel.snp.top).offset(2*ConstantsManager.standardHeight)
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.leading.equalTo(explainButton.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.top.equalTo(explainButton)
        }
        
        frequencyLabel.snp.makeConstraints { make in
            make.height.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorTitleLabel.snp.bottom).offset(3*ConstantsManager.standardHeight)
        }
        
        noticeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16*ConstantsManager.standardWidth)
            make.top.equalTo(frequencyLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.height.equalTo(38*ConstantsManager.standardHeight).priority(.high)
            make.leading.trailing.equalToSuperview().inset(16*ConstantsManager.standardWidth)
            make.top.equalTo(noticeButton.snp.bottom).offset(8*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
    }
}
