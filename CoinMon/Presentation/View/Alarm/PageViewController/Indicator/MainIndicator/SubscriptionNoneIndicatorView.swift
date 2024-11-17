import UIKit
import SnapKit

class SubscriptionNoneIndicatorView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let hbbIndicatorView = HBBIndicatorView()
    let maIndicatorView = MAIndicatorView()
    let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.gray_99
        return view
    }()
    let noticeCoinLabel: UILabel = {
        let label = UILabel()
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
        hbbIndicatorView.indicatorLabel.text = LocalizationManager.shared.localizedString(forKey: "하이퍼 볼린저밴드")
        hbbIndicatorView.explainLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "역추세 볼린저밴드와 볼린저밴드를 합친 지표"))
        hbbIndicatorView.noticeLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "구독중인 Coinmon Premium 알림받을 코인을 선택해 주세요"))
        hbbIndicatorView.selectOtherCoinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "다른 코인 선택하기"), for: .normal)
        maIndicatorView.indicatorLabel.text = LocalizationManager.shared.localizedString(forKey: "이동평균선")
        maIndicatorView.explainLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "일정 기간 동안 가격 평균을 측정하는 지표"))
        maIndicatorView.selectOtherCoinButton.setTitle(LocalizationManager.shared.localizedString(forKey: "다른 코인 선택하기"), for: .normal)
        noticeCoinLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "구독 안내 설명"))
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [hbbIndicatorView,maIndicatorView,grayView]
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
        
        hbbIndicatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(16*ConstantsManager.standardHeight)
        }
        
        maIndicatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20*ConstantsManager.standardWidth)
            make.top.equalTo(hbbIndicatorView.snp.bottom).offset(16*ConstantsManager.standardHeight)
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
