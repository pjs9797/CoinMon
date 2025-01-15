import UIKit

class BottomButtonA: BaseButton {
    var title: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateTitle(_ text: String) {
        guard var currentConfig = self.configuration else { return }
        title = text
        // 새로운 타이틀을 설정
        if let fontStyle = self.fontStyle {
            if let attributedTitle = FontManagerA.createAttributedString(text: text, style: fontStyle) {
                currentConfig.attributedTitle = attributedTitle
            }
        } else {
            currentConfig.title = text
        }

        // 업데이트된 설정을 버튼에 적용
        self.configuration = currentConfig
    }

    
    private func configureButton() {
        self.setConfiguration(
            title: "",
            fontStyle: FontManagerA.D6_16,
            foregroundColor: ColorManager.common_100,
            backgroundColor: ColorManager.orange_60
        )
        
        self.layer.cornerRadius = 12 * ConstantsManager.standardHeight
        self.clipsToBounds = true
    }
    
    func isNotEnable() {
        self.setConfiguration(
            title: title ?? "",
            fontStyle: FontManagerA.D6_16,
            foregroundColor: ColorManager.common_100,
            backgroundColor: ColorManager.gray_90
        )
        self.isEnabled = false
    }
    
    func isEnable() {
        self.setConfiguration(
            title: title ?? "",
            fontStyle: FontManagerA.D6_16,
            foregroundColor: ColorManager.common_100,
            backgroundColor: ColorManager.orange_60
        )
        self.isEnabled = true
    }
}


class BottomButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        self.backgroundColor = ColorManager.orange_60
        self.layer.cornerRadius = 12*ConstantsManager.standardHeight
        self.titleLabel?.font = FontManager.D6_16
        self.setTitleColor(ColorManager.common_100, for: .normal)
        self.setTitleColor(ColorManager.common_100?.withAlphaComponent(0.6), for: .highlighted)
    }
    
    func isNotEnable(){
        self.backgroundColor = ColorManager.gray_90
        self.isEnabled = false
    }
    
    func isEnable(){
        self.backgroundColor = ColorManager.orange_60
        self.isEnabled = true
    }
}
