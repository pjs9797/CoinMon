import UIKit
import SnapKit

class SuccessSubscriptionView: UIView {
    let subscribePeriodView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        view.layer.cornerRadius = 16*ConstantsManager.standardHeight
        return view
    }()
    let coinmonPremiumLabel: UILabel = {
        let label = UILabel()
        label.text = "Coinmon Premium"
        label.font = FontManager.D4_20
        label.textColor = ColorManager.common_0
        return label
    }()
    let subscribePeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "이용 기간 :  YYYY년 NN월 DD일까지"
        label.font = FontManager.B5_14
        label.textColor = ColorManager.gray_20
        return label
    }()
    let planLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "이용 중인 플랜")
        label.font = FontManager.B5_14
        label.textColor = ColorManager.gray_20
        return label
    }()
    let boonButton: UIButton = {
        let button = ConfigurationButton(font: FontManager.D9_13, foregroundColor: ColorManager.orange_60, backgroundColor: ColorManager.orange_95)
        var configuration = button.configuration
        configuration?.title = LocalizationManager.shared.localizedString(forKey: "최고혜택")
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 3*ConstantsManager.standardHeight, leading: 8*ConstantsManager.standardWidth, bottom: 3*ConstantsManager.standardHeight, trailing: 8*ConstantsManager.standardWidth)
        button.configuration = configuration
        button.layer.cornerRadius = 12 * ConstantsManager.standardHeight
        button.clipsToBounds = true
        return button
    }()
    let checkImageView1: UIImageView = {
        let imageView = UIImageView()
        let image = ImageManager.check24?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorManager.common_0 ?? .black
        imageView.image = image
        return imageView
    }()
    let checkImageView2: UIImageView = {
        let imageView = UIImageView()
        let image = ImageManager.check24?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorManager.common_0 ?? .black
        imageView.image = image
        return imageView
    }()
    let checkImageView3: UIImageView = {
        let imageView = UIImageView()
        let image = ImageManager.check24?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ColorManager.common_0 ?? .black
        imageView.image = image
        return imageView
    }()
    let boonLabel1: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.T4_15
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저밴드 지표 매수•매도 타이밍 알림"))
        label.textColor = ColorManager.common_0
        return label
    }()
    let boonLabel2: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.T4_15
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "24시간 질문, 상담 가능"))
        label.textColor = ColorManager.common_0
        return label
    }()
    let boonLabel3: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.T4_15
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "프리미엄 구독자만 참여 가능한 선물 이벤트"))
        label.textColor = ColorManager.common_0
        return label
    }()
    let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        return view
    }()
    let explainSubscribeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.B5_14
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "구독 안내 설명"))
        label.textColor = ColorManager.gray_60
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [subscribePeriodView,planLabel,boonButton,boonLabel1,checkImageView1,boonLabel2,checkImageView2,boonLabel3,checkImageView3,grayView]
            .forEach{
                addSubview($0)
            }
        
        [coinmonPremiumLabel,subscribePeriodLabel]
            .forEach{
                subscribePeriodView.addSubview($0)
            }
        
        grayView.addSubview(explainSubscribeLabel)

        subscribePeriodView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        coinmonPremiumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        subscribePeriodLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalTo(coinmonPremiumLabel.snp.bottom).offset(4*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
        
        planLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(subscribePeriodView.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        boonButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalTo(planLabel.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        boonLabel1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(48*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(boonButton.snp.bottom).offset(12*ConstantsManager.standardHeight)
        }
        
        checkImageView1.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.trailing.equalTo(boonLabel1.snp.leading).offset(-8*ConstantsManager.standardHeight)
            make.centerY.equalTo(boonLabel1)
        }
        
        boonLabel2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(48*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(boonLabel1.snp.bottom).offset(10*ConstantsManager.standardHeight)
        }
        
        checkImageView2.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.trailing.equalTo(boonLabel2.snp.leading).offset(-8*ConstantsManager.standardHeight)
            make.centerY.equalTo(boonLabel2)
        }
        
        boonLabel3.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(48*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(boonLabel2.snp.bottom).offset(10*ConstantsManager.standardHeight)
        }
        
        checkImageView3.snp.makeConstraints { make in
            make.width.height.equalTo(20*ConstantsManager.standardHeight)
            make.trailing.equalTo(boonLabel3.snp.leading).offset(-8*ConstantsManager.standardHeight)
            make.centerY.equalTo(boonLabel3)
        }
        
        grayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        explainSubscribeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-54*ConstantsManager.standardHeight)
        }
    }
}
