import UIKit
import SnapKit

class NormalNoneIndicatorView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let hbbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageManager.ExplainHyperBollingerBands_ko
        return imageView
    }()
    let trialButton: BottomButton = {
        let button = BottomButton()
        return button
    }()
    let viewOtherIndicatorButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.gray_60, for: .normal)
        button.titleLabel?.font = FontManager.T5_14
        return button
    }()
    let maIndicatorView = MAIndicatorView()
    let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        return view
    }()
    let noticeCoinLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = AttributedFontManager.B5_14
        label.textColor = ColorManager.gray_70
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        trialButton.setTitle(LocalizationManager.shared.localizedString(forKey: "14일 무료 체험하기"), for: .normal)
        viewOtherIndicatorButton.setTitle(LocalizationManager.shared.localizedString(forKey: "다른 지표 보기"), for: .normal)
        maIndicatorView.indicatorLabel.text = LocalizationManager.shared.localizedString(forKey: "이동평균선")
        maIndicatorView.explainLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "일정 기간 동안 가격 평균을 측정하는 지표"))
        maIndicatorView.selectOtherCoinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "다른 코인 선택하기"), for: .normal)
        noticeCoinLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "코인 투자 안내"))
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [hbbImageView,trialButton,viewOtherIndicatorButton,maIndicatorView,grayView]
            .forEach{
                contentView.addSubview($0)
            }
        
        grayView.addSubview(noticeCoinLabel)
        
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
        
        hbbImageView.snp.makeConstraints { make in
            make.height.equalTo(388*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        trialButton.snp.makeConstraints { make in
            make.height.equalTo(52*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalTo(hbbImageView.snp.bottom).offset(8*ConstantsManager.standardHeight)
        }
        
        viewOtherIndicatorButton.snp.makeConstraints { make in
            make.height.equalTo(22*ConstantsManager.standardHeight)
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalTo(trialButton.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        maIndicatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalTo(viewOtherIndicatorButton.snp.bottom).offset(40*ConstantsManager.standardHeight)
        }
        
        grayView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(maIndicatorView.snp.bottom).offset(50*ConstantsManager.standardHeight)
            make.bottom.equalToSuperview()
        }
        
        noticeCoinLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.bottom.equalToSuperview().inset(40*ConstantsManager.standardHeight)
        }
    }
}
