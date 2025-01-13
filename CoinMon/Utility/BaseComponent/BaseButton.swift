import UIKit

class BaseButton: UIButton {
    private var fontStyle: FontStyle?
    
    func setConfiguration(title: String, fontStyle: FontStyle, foregroundColor: UIColor? = ColorManager.common_0, backgroundColor: UIColor? = ColorManager.common_100) {
        self.fontStyle = fontStyle
        
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = backgroundColor
        buttonConfig.baseForegroundColor = foregroundColor
        buttonConfig.cornerStyle = .medium
        
        if let attributedTitle = FontManagerA.createAttributedString(text: title, style: fontStyle) {
            buttonConfig.attributedTitle = attributedTitle
        }
        
        buttonConfig.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var attributes = incoming
            attributes.font = fontStyle.font
            attributes.foregroundColor = foregroundColor
            return attributes
        }
        
        if let attributedTitle = FontManagerA.createAttributedString(text: title, style: fontStyle) {
            buttonConfig.attributedTitle = attributedTitle
        }
        
        self.configuration = buttonConfig
        
        self.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var updatedConfig = button.configuration ?? UIButton.Configuration.filled()
            updatedConfig.background.backgroundColor = backgroundColor
            button.configuration = updatedConfig
        }
    }
    
    func updateTitle(_ text: String) {
        guard let style = self.fontStyle, var config = self.configuration else { return }
        
        if let attributedTitle = FontManagerA.createAttributedString(text: text, style: style) {
            config.attributedTitle = attributedTitle
        }
        
        self.configuration = config
    }
    
    func setContentInsets(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        guard var config = self.configuration else { return }
        
        config.contentInsets = NSDirectionalEdgeInsets(
            top: top * ConstantsManager.standardHeight,
            leading: leading * ConstantsManager.standardWidth,
            bottom: bottom * ConstantsManager.standardHeight,
            trailing: trailing * ConstantsManager.standardWidth
        )
        
        self.configuration = config
    }
    
    func setImage(image: UIImage?, color: UIColor? = nil, placement: NSDirectionalRectEdge = .leading, padding: CGFloat? = nil) {
        guard var config = self.configuration else { return }

        if let color = color {
            config.image = image?.withTintColor(color, renderingMode: .alwaysTemplate)
        } else {
            config.image = image
        }

        config.imagePlacement = placement
        config.imagePadding = (padding ?? 0) * ConstantsManager.standardWidth

        self.configuration = config
    }

}
