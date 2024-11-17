import UIKit
import SnapKit

class TryNewIndicatorView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let imageView1: UIImageView = {
        let imageView = UIImageView()
        if LocalizationManager.shared.language == "ko" {
            imageView.image = ImageManager.tryNewIndicator_ko
        }
        else {
            imageView.image = ImageManager.tryNewIndicator_en
        }
        imageView.layer.cornerRadius = 20*ConstantsManager.standardHeight
        return imageView
    }()
    let explainLabel1: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.D4_20
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저밴드 지표로 매수•매도 타이밍 알림 받아요"))
        label.textColor = ColorManager.common_0
        return label
    }()
    let imageView2: UIImageView = {
        let imageView = UIImageView()
        if LocalizationManager.shared.language == "ko" {
            imageView.image = ImageManager.tryNewIndicator2_ko
        }
        else {
            imageView.image = ImageManager.tryNewIndicator2_en
        }
        imageView.layer.cornerRadius = 20*ConstantsManager.standardHeight
        return imageView
    }()
    let explainIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return view
    }()
    let explainIndicatorLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저밴드가 뭔가요?")
        label.font = FontManager.H6_14
        label.textColor = ColorManager.gray_20
        return label
    }()
    let explainIndicatorButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString(LocalizationManager.shared.localizedString(forKey: "설명보기"), attributes: .init([.font: FontManager.B5_14]))
        configuration.baseForegroundColor = ColorManager.gray_20
        configuration.baseBackgroundColor = ColorManager.gray_99
        configuration.image = ImageManager.arrow_Chevron_Right?.withTintColor(ColorManager.gray_20 ?? .black, renderingMode: .alwaysTemplate)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 3*ConstantsManager.standardWidth
        let button = UIButton(configuration: configuration)
        return button
    }()
    let explainLabel2: UILabel = {
        let label = UILabel()
        label.text = LocalizationManager.shared.localizedString(forKey: "내가 관심있는 코인만 알림 받기")
        label.font = FontManager.D3_22
        label.textColor = ColorManager.common_0
        return label
    }()
    let explainLabel3: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.B3_16
        label.textColor = ColorManager.gray_20
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "현재 관심 있거나 매수•매도가 필요한 코인을 지정할 수 있어요"))
        return label
    }()
    let imageView3: UIImageView = {
        let imageView = UIImageView()
        if LocalizationManager.shared.language == "ko" {
            imageView.image = ImageManager.tryNewIndicator3_ko
        }
        else {
            imageView.image = ImageManager.tryNewIndicator3_en
        }
        imageView.layer.cornerRadius = 20*ConstantsManager.standardHeight
        return imageView
    }()
    let explainLabel4: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.D3_22
        label.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "24시간 고객센터에서 언제든지 도움을 요청할 수 있어요"))
        label.textColor = ColorManager.common_0
        return label
    }()
    let imageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.tryNewIndicator4
        imageView.layer.cornerRadius = 20*ConstantsManager.standardHeight
        return imageView
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
    let trialButton: BottomButton = {
        let button = BottomButton()
        button.setTitle(LocalizationManager.shared.localizedString(forKey: "14일 무료 체험하기"), for: .normal)
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
        scrollView.contentInsetAdjustmentBehavior = .never

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [imageView1,explainLabel1,imageView2,explainIndicatorView,explainLabel2,explainLabel3,imageView3,explainLabel4,imageView4,grayView,trialButton]
            .forEach{
                contentView.addSubview($0)
            }
        [explainIndicatorLabel,explainIndicatorButton]
            .forEach{
                explainIndicatorView.addSubview($0)
            }
        grayView.addSubview(explainSubscribeLabel)
        
        scrollView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.edges.equalToSuperview()
        }
        
        imageView1.snp.makeConstraints { make in
            make.height.equalTo(520*ConstantsManager.standardHeight)
            make.leading.trailing.top.equalToSuperview()
        }
        
        explainLabel1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(imageView1.snp.bottom).offset(56*ConstantsManager.standardHeight)
        }
        
        imageView2.snp.makeConstraints { make in
            make.height.equalTo(360*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(explainLabel1.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        explainIndicatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(imageView2.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        explainIndicatorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.top.bottom.equalToSuperview().inset(16 * ConstantsManager.standardHeight)
        }
        
        explainIndicatorButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16*ConstantsManager.standardWidth)
            make.centerY.equalTo(explainIndicatorLabel)
        }
        
        explainLabel2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(explainIndicatorView.snp.bottom).offset(90*ConstantsManager.standardHeight)
        }
        
        explainLabel3.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(explainLabel2.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        imageView3.snp.makeConstraints { make in
            make.height.equalTo(360*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(explainLabel3.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        explainLabel4.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(imageView3.snp.bottom).offset(90*ConstantsManager.standardHeight)
        }
        
        imageView4.snp.makeConstraints { make in
            make.height.equalTo(360*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(explainLabel4.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        grayView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(imageView4.snp.bottom).offset(100*ConstantsManager.standardHeight)
        }
        
        explainSubscribeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.bottom.equalToSuperview().inset(20*ConstantsManager.standardHeight)
        }
        
        trialButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(grayView.snp.bottom).offset(8*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview().offset(-8*ConstantsManager.standardHeight)
        }
    }
}
