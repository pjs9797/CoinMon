import UIKit
import SnapKit

class InquiryView: UIView {
    let inquiryLabel: UILabel = {
        let label = UILabel()
        label.font = FontManager.D5_18
        label.textColor = ColorManager.common_0
        label.numberOfLines = 0
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
        inquiryLabel.text = LocalizationManager.shared.localizedString(forKey: "으로 문의 바랍니다", arguments: "coinmoncp@gmail.com")
    }
    
    private func layout() {
        [inquiryLabel]
            .forEach{
                addSubview($0)
            }
        
        inquiryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-20*Constants.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(32*Constants.standardHeight)
        }
    }
}
