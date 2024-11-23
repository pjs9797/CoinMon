import UIKit
import RxSwift
import SnapKit

class ExplanIndicatorTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
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
        let button = ConfigurationButton(font: FontManager.D8_14, foregroundColor: ColorManager.gray_20, backgroundColor: ColorManager.common_100)
        var configuration = button.configuration
        configuration?.title = LocalizationManager.shared.localizedString(forKey: "알림 받는 중2")
        configuration?.image = ImageManager.check20
        configuration?.imagePadding = 4
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8*ConstantsManager.standardHeight, leading: 8*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, trailing: 14*ConstantsManager.standardWidth)
        button.configuration = configuration
        button.layer.cornerRadius = 8 * ConstantsManager.standardHeight
        button.layer.borderColor = ColorManager.gray_96?.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    let trialButton: UIButton = {
        let button = ConfigurationButton(font: FontManager.D8_14, foregroundColor: ColorManager.common_100, backgroundColor: ColorManager.orange_60)
        var configuration = button.configuration
        configuration?.title = LocalizationManager.shared.localizedString(forKey: "14일 무료 체험하기")
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8*ConstantsManager.standardHeight, leading: 100*ConstantsManager.standardWidth, bottom: 8*ConstantsManager.standardHeight, trailing: 100*ConstantsManager.standardWidth)
        button.configuration = configuration
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
        [indicatorTitleLabel,explainButton,premiumLabel,rightButton,explainLabel,alarmButton,trialButton]
            .forEach {
                contentView.addSubview($0)
            }
        
        indicatorTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(indicatorTitleLabel.intrinsicContentSize.width).priority(.high)
            make.height.greaterThanOrEqualTo(24*ConstantsManager.standardHeight)
            make.leading.equalToSuperview()
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
        
        if indicatorInfo.indicatorId == 1 && subscriptionStatus?.status == .normal {
            rightButton.isHidden = true
        }
        else {
            rightButton.isHidden = false
        }
        
        if let subscriptionStatus = subscriptionStatus,
           indicatorInfo.indicatorId == 1,
           subscriptionStatus.status == .normal{
            if subscriptionStatus.useTrialYN == "Y" {
                trialButton.configuration?.title = LocalizationManager.shared.localizedString(forKey: "프리미엄 구독하기")
            }
            else {
                trialButton.configuration?.title = LocalizationManager.shared.localizedString(forKey: "14일 무료 체험하기")
            }
            trialButton.isHidden = false
            alarmButton.isHidden = true
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
