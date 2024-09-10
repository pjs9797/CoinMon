import UIKit

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
