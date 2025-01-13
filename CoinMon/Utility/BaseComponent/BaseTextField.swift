import UIKit

class BaseTextField: UITextField {
    private var fontStyle: FontStyle?

    func setStyle(text: String? = nil, placeholder: String?, style: FontStyle, textColor: UIColor? = ColorManager.common_0) {
        self.fontStyle = style
        self.font = style.font
        self.textColor = textColor

        if let text = text {
            self.text = text
        }

        if let placeholder = placeholder {
            self.attributedPlaceholder = FontManagerA.createAttributedString(text: placeholder, style: style).flatMap { NSAttributedString($0) }
        }

        updateTextAttributes()
    }
    
    func updateText(_ newText: String) {
        self.text = newText
        updateTextAttributes()
    }
    
    private func updateTextAttributes() {
        guard let style = fontStyle, let currentText = self.text else { return }

        let attributedString = NSMutableAttributedString(string: currentText)
        attributedString.addAttribute(.kern, value: style.letterSpacing, range: NSRange(location: 0, length: attributedString.length))

        self.attributedText = attributedString
    }
}
