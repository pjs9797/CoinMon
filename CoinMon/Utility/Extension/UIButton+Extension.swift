import UIKit

extension UIButton {
    func setUnderline() {
        guard var config = self.configuration else {
            // Fallback for older button setup
            if let title = title(for: .normal) {
                let attributedString = NSMutableAttributedString(string: title)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center

                attributedString.addAttributes([
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .paragraphStyle: paragraphStyle,
                    .baselineOffset: 3 * ConstantsManager.standardHeight
                ], range: NSRange(location: 0, length: title.count))

                setAttributedTitle(attributedString, for: .normal)
            }
            return
        }

        if let title = config.title {
            let attributedString = NSMutableAttributedString(string: title)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center

            attributedString.addAttributes([
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .paragraphStyle: paragraphStyle,
                .baselineOffset: 3 * ConstantsManager.standardHeight
            ], range: NSRange(location: 0, length: title.count))

            config.attributedTitle = AttributedString(attributedString)
            self.configuration = config
        }
    }
}
