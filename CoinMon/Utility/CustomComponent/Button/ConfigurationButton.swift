import UIKit

class ConfigurationButton: UIButton {
    init(configurationType: UIButton.Configuration = .filled(),
         font: UIFont = FontManager.H6_14,
         foregroundColor: UIColor? = ColorManager.common_0,
         backgroundColor: UIColor? = ColorManager.common_100) {
        super.init(frame: .zero)
        
        var config = configurationType
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var attributes = incoming
            attributes.font = font
            attributes.foregroundColor = foregroundColor
            return attributes
        }
        
        configurationUpdateHandler = { button in
            var updatedConfiguration = button.configuration ?? UIButton.Configuration.filled()
            updatedConfiguration.background.backgroundColor = backgroundColor
            button.configuration = updatedConfiguration
        }
        
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
