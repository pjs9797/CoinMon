import UIKit

class BottomButtonA: BaseButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateTitle(_ text: String) {
        // 기존 `setConfiguration` 재호출로 타이틀을 안전하게 갱신
        self.setConfiguration(
            title: text,
            fontStyle: FontManagerA.D6_16,
            foregroundColor: ColorManager.common_100,
            backgroundColor: ColorManager.orange_60
        )
    }
    
    private func configureButton() {
        self.setConfiguration(
            title: "",
            fontStyle: FontManagerA.D6_16,
            foregroundColor: ColorManager.common_100,
            backgroundColor: ColorManager.orange_60
        )
        
        self.layer.cornerRadius = 12 * ConstantsManager.standardHeight
    }
    
    func isNotEnable() {
        self.setConfiguration(
            title: self.currentTitle ?? "",
            fontStyle: FontManagerA.D6_16,
            foregroundColor: ColorManager.common_100?.withAlphaComponent(0.6),
            backgroundColor: ColorManager.gray_90
        )
        self.isEnabled = false
    }
    
    func isEnable() {
        self.setConfiguration(
            title: self.currentTitle ?? "",
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
