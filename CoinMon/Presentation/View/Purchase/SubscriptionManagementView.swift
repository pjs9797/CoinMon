import UIKit
import SnapKit

class SubscriptionManagementView: UIView {
    let planView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        view.layer.cornerRadius = 16*ConstantsManager.standardHeight
        return view
    }()
    let planLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "이용 중인 플랜")
        label.font = FontManager.B4_15
        label.textColor = ColorManager.gray_20
        return label
    }()
    let coinmonPremiumLabel: UILabel = {
        let label = UILabel()
        label.text = "Coinmon Premium"
        label.font = FontManager.H5_15
        label.textColor = ColorManager.common_0
        return label
    }()
    let dueDateLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "결제 예정일")
        label.font = FontManager.B4_15
        label.textColor = ColorManager.gray_20
        return label
    }()
    let subscribePeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "YYYY년 NN월 DD일까지"
        label.font = FontManager.H5_15
        label.textColor = ColorManager.gray_20
        return label
    }()
    let questionLabel1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.H5_15
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "구독은 어떻게 취소하나요?"))
        label.textColor = ColorManager.gray_20
        return label
    }()
    let answerLabel1: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.B5_14
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "• IOS 설정 > Apple ID 선택 > 구독에서 구독을 관리하고 자동 갱신을 해지할 수 있습니다."))
        label.textColor = ColorManager.gray_60
        return label
    }()
    let questionLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.H5_15
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "구독을 취소하면 이용 중이던 알림은 어떻게 되나요?"))
        label.textColor = ColorManager.gray_20
        return label
    }()
    let answerLabel2: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.B5_14
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "• 구독을 취소하면 이미 결제한 해당월의 다음 결제일 전까지는 Premium 혜택을 그대로 사용할 수 있고, 다음 결제일부터 요금이 청구되지 않으며 Premium으로 이용 중이던 지표는 비활성화됩니다."))
        label.textColor = ColorManager.gray_60
        return label
    }()
    let moreQuestionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        view.layer.borderColor = ColorManager.gray_96?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let moreQuestionLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "더 궁금한 점이 있으신가요?")
        label.font = FontManager.T5_14
        label.textColor = ColorManager.gray_20
        return label
    }()
    let contactButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "문의하기"), attributes: .init([.font: FontManager.B5_14]))
        configuration.baseForegroundColor = ColorManager.gray_20
        configuration.baseBackgroundColor = ColorManager.common_100
        configuration.image = ImageManager.arrow_Chevron_Right?.withTintColor(ColorManager.gray_20 ?? .black, renderingMode: .alwaysTemplate)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 3*ConstantsManager.standardWidth
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [planView,questionLabel1,answerLabel1,questionLabel2,answerLabel2,moreQuestionView]
            .forEach{
                addSubview($0)
            }
        
        [planLabel,coinmonPremiumLabel,dueDateLabel,subscribePeriodLabel]
            .forEach{
                planView.addSubview($0)
            }
        
        [moreQuestionLabel,contactButton]
            .forEach{
                moreQuestionView.addSubview($0)
            }
        
        planView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16*ConstantsManager.standardHeight)
        }
        
        planLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        coinmonPremiumLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        dueDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalTo(planLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
        
        subscribePeriodLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
            make.top.equalTo(coinmonPremiumLabel.snp.bottom).offset(6*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
        
        questionLabel1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(planView.snp.bottom).offset(24*ConstantsManager.standardHeight)
        }
        
        answerLabel1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(questionLabel1.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        questionLabel2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(answerLabel1.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        answerLabel2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(questionLabel2.snp.bottom).offset(6*ConstantsManager.standardHeight)
        }
        
        moreQuestionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(answerLabel2.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        moreQuestionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
        
        contactButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-16*ConstantsManager.standardHeight)
        }
    }
}
