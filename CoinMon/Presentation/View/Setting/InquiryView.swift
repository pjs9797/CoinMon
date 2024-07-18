import UIKit
import SnapKit

class InquiryView: UIView {
    let inquiryLabelBackView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.orange_99
        view.layer.cornerRadius = 12*ConstantsManager.standardHeight
        return view
    }()
    let inquiryLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.gray_15
        label.font = FontManager.T5_14
        return label
    }()
    let discordButton: InquiryButton = {
        let button = InquiryButton()
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.titleLabel?.font = FontManager.H4_16
        return button
    }()
    let kakaoButton: InquiryButton = {
        let button = InquiryButton()
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.titleLabel?.font = FontManager.H4_16
        return button
    }()
    let telegramButton: InquiryButton = {
        let button = InquiryButton()
        button.setTitleColor(ColorManager.common_0, for: .normal)
        button.titleLabel?.font = FontManager.H4_16
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocalizedText(){
        inquiryLabel.text = LocalizationManager.shared.localizedString(forKey: "자주 사용하는 채널로 문의해 주세요")
        discordButton.setTitle(LocalizationManager.shared.localizedString(forKey: "디스코드"), for: .normal)
        kakaoButton.setTitle(LocalizationManager.shared.localizedString(forKey: "카카오톡 오픈채팅"), for: .normal)
        telegramButton.setTitle(LocalizationManager.shared.localizedString(forKey: "텔레그램"), for: .normal)
    }
    
    private func layout() {
        [inquiryLabelBackView,discordButton,kakaoButton,telegramButton]
            .forEach{
                addSubview($0)
            }
        
        inquiryLabelBackView.addSubview(inquiryLabel)
        
        inquiryLabelBackView.snp.makeConstraints { make in
            make.height.equalTo(54*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(8*ConstantsManager.standardHeight)
        }
        
        inquiryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*ConstantsManager.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        discordButton.snp.makeConstraints { make in
            make.height.equalTo(64*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(inquiryLabelBackView.snp.bottom).offset(16*ConstantsManager.standardHeight)
        }
        
        kakaoButton.snp.makeConstraints { make in
            make.height.equalTo(64*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(discordButton.snp.bottom)
        }
        
        telegramButton.snp.makeConstraints { make in
            make.height.equalTo(64*ConstantsManager.standardHeight)
            make.leading.equalToSuperview().offset(20*ConstantsManager.standardWidth)
            make.trailing.equalToSuperview().offset(-20*ConstantsManager.standardWidth)
            make.top.equalTo(kakaoButton.snp.bottom)
        }
    }
}
