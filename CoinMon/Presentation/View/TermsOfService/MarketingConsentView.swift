import UIKit
import SnapKit

class MarketingConsentView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let marketingConsentLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.T5_14
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLocalizedText()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        marketingConsentLabel.text = LocalizationManager.shared.localizedString(forKey: "마케팅활용동의")
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(marketingConsentLabel)
        
        scrollView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.edges.equalToSuperview()
        }
        
        marketingConsentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.top.equalToSuperview().offset(20*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.bottom.equalToSuperview().offset(-20*Constants.standardHeight)
        }
    }
}
