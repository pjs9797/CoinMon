import UIKit
import SnapKit

class TermsOfServiceView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let termsOfServiceLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedFontManager.T5_14
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
        termsOfServiceLabel.updateAttributedText(LocalizationManager.shared.localizedString(forKey: "서비스이용약관"))
    }
    
    private func layout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(termsOfServiceLabel)
        
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
        
        termsOfServiceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.top.equalToSuperview().offset(20*ConstantsManager.standardHeight)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.bottom.equalToSuperview().offset(-20*ConstantsManager.standardHeight)
        }
    }
}
