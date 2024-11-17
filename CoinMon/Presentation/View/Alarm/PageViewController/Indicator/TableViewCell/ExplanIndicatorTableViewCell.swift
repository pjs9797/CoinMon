import UIKit
import RxSwift
import SnapKit

class ExplanIndicatorTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    let indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = ColorManager.gray_80
        return imageView
    }()
    let indicatorTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = FontManager.D6_16
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
    let explainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.B6_13
        label.textColor = ColorManager.gray_40
        return label
    }()
    let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageManager.arrow_Right, for: .normal)
        return button
    }()
    let alarmButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "알림 받는 중2"), attributes: .init([.font: FontManager.D8_14]))
        configuration.image = ImageManager.check20
        configuration.imagePadding = 4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8*ConstantsManager.standardHeight, leading: 8*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, trailing: 14*ConstantsManager.standardWidth)
        configuration.baseForegroundColor = ColorManager.gray_20
        configuration.baseBackgroundColor = ColorManager.common_100

        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 8 * ConstantsManager.standardHeight
        button.layer.borderColor = ColorManager.gray_96?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let trialButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "14일 무료 체험하기"), attributes: .init([.font: FontManager.D8_14]))
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8*ConstantsManager.standardHeight, leading: 14*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, trailing: 14*ConstantsManager.standardWidth)
        configuration.baseForegroundColor = ColorManager.common_100
        configuration.baseBackgroundColor = ColorManager.orange_60

        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 8 * ConstantsManager.standardHeight
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
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
        [indicatorImageView,indicatorTitleLabel,explainButton,premiumLabel,rightButton,explainLabel,alarmButton,trialButton]
            .forEach {
                contentView.addSubview($0)
            }
        
        indicatorImageView.snp.makeConstraints { make in
            make.height.width.equalTo(50*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        indicatorTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(indicatorTitleLabel.intrinsicContentSize.width).priority(.high)
            make.height.greaterThanOrEqualTo(24*ConstantsManager.standardHeight)
            make.leading.equalTo(indicatorImageView.snp.trailing).offset(8*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        explainButton.snp.makeConstraints { make in
            make.height.width.equalTo(18*ConstantsManager.standardHeight)
            make.leading.equalTo(indicatorTitleLabel.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorTitleLabel)
        }
        
        premiumLabel.snp.makeConstraints { make in
            make.leading.equalTo(explainButton.snp.trailing).offset(4*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-28*ConstantsManager.standardWidth)
            make.centerY.equalTo(indicatorTitleLabel)
        }
        
        rightButton.snp.makeConstraints { make in
            make.height.width.equalTo(20*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.leading.equalTo(indicatorTitleLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-28*ConstantsManager.standardWidth)
            make.top.equalTo(indicatorTitleLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.leading.equalTo(indicatorTitleLabel.snp.leading)
            make.top.equalTo(explainLabel.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        trialButton.snp.makeConstraints { make in
            make.leading.equalTo(indicatorTitleLabel.snp.leading)
            make.top.equalTo(explainLabel.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
    }
    
    func configure(with indicatorInfo: IndicatorInfo, subscriptionStatus: UserSubscriptionStatus? = nil) {
        // 공통 설정
        indicatorTitleLabel.text = indicatorInfo.indicatorName
        explainLabel.text = indicatorInfo.indicatorDescription
        premiumLabel.isHidden = indicatorInfo.isPremiumYN != "Y"
        
        if indicatorInfo.indicatorId == 1 {
            rightButton.isHidden = true
        }
        else {
            rightButton.isHidden = false
        }

        if let subscriptionStatus = subscriptionStatus,
           indicatorInfo.indicatorId == 1,
           subscriptionStatus.status == .normal,
           subscriptionStatus.useTrialYN == "N" {
            trialButton.isHidden = false
            explainLabel.snp.remakeConstraints { make in
                make.leading.equalTo(indicatorTitleLabel.snp.leading)
                make.trailing.equalToSuperview().offset(-28 * ConstantsManager.standardWidth)
                make.top.equalTo(indicatorTitleLabel.snp.bottom).offset(6 * ConstantsManager.standardHeight)
            }

            trialButton.snp.remakeConstraints { make in
                make.leading.equalTo(indicatorTitleLabel.snp.leading)
                make.top.equalTo(explainLabel.snp.bottom).offset(12 * ConstantsManager.standardHeight)
                make.bottom.equalToSuperview().offset(-20 * ConstantsManager.standardHeight).priority(.low)
            }
        } 
        else {
            trialButton.isHidden = true
            if indicatorInfo.isPushed {
                alarmButton.isHidden = false
                explainLabel.snp.remakeConstraints { make in
                    make.leading.equalTo(indicatorTitleLabel.snp.leading)
                    make.trailing.equalToSuperview().offset(-28 * ConstantsManager.standardWidth)
                    make.top.equalTo(indicatorTitleLabel.snp.bottom).offset(6 * ConstantsManager.standardHeight)
                }

                alarmButton.snp.remakeConstraints { make in
                    make.leading.equalTo(indicatorTitleLabel.snp.leading)
                    make.top.equalTo(explainLabel.snp.bottom).offset(12 * ConstantsManager.standardHeight)
                    make.bottom.equalToSuperview().offset(-20 * ConstantsManager.standardHeight).priority(.low)
                }
            }
            else {
                alarmButton.isHidden = true
                explainLabel.snp.remakeConstraints { make in
                    make.leading.equalTo(indicatorTitleLabel.snp.leading)
                    make.trailing.equalToSuperview().offset(-28 * ConstantsManager.standardWidth)
                    make.top.equalTo(indicatorTitleLabel.snp.bottom).offset(6 * ConstantsManager.standardHeight)
                    make.bottom.equalToSuperview().offset(-24 * ConstantsManager.standardHeight)
                }
            }
        }
    }
}
