import UIKit

class BaseLabel: UILabel {
    private var fontStyle: FontStyle?

    func setStyle(text: String, fontStyle: FontStyle, textColor: UIColor? = ColorManager.common_0) {
        self.fontStyle = fontStyle
        self.font = fontStyle.font
        self.textColor = textColor

        if let attributedString = FontManagerA.createAttributedString(text: text, style: fontStyle) {
            self.attributedText = NSAttributedString(attributedString)
        } else {
            print("⚠️ Failed to create attributed string for label.")
        }
    }

    func updateText(_ text: String) {
        guard let style = self.fontStyle else {
            print("⚠️ FontStyle is not set. Cannot update text.")
            return
        }
        
        if let attributedString = FontManagerA.createAttributedString(text: text, style: style) {
            self.attributedText = NSAttributedString(attributedString)
        } else {
            print("⚠️ Failed to create attributed string for updated text.")
        }
    }
}
