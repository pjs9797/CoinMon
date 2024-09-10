import UIKit

extension UILabel {
    func updateAttributedText(_ newText: String) {
        guard let existingAttributedText = self.attributedText else { return }
        let mutableAttributedText = NSMutableAttributedString(attributedString: existingAttributedText)
        mutableAttributedText.mutableString.setString(newText)
        self.attributedText = mutableAttributedText
    }
}
