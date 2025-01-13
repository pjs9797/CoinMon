import UIKit

class BaseTextView: UITextView {
    private var fontStyle: FontStyle?
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)

        // 커서 높이를 폰트 크기에 맞게 조정
        if let font = self.font {
            rect.size.height = font.lineHeight
            rect.origin.y += (fontStyle!.lineHeight - font.lineHeight) / 2
        }

        return rect
    }

    func setStyle(text: String, style: FontStyle) {
        self.fontStyle = style
        self.font = style.font
        self.text = text

        // AttributedString 생성
        if let attributedString = FontManagerA.createAttributedString(text: text, style: style) {
            let mutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(attributedString))

            // NSParagraphStyle 설정
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = style.lineHeight
            paragraphStyle.maximumLineHeight = style.lineHeight
            paragraphStyle.alignment = .left

            mutableAttributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: mutableAttributedString.length)
            )

            self.attributedText = mutableAttributedString
        }
    }

    func addLinks(links: [String: URL], linkColor: UIColor? = ColorManager.gray_50, defaultColor: UIColor? = ColorManager.gray_70) {
        guard let currentText = self.text else { return }

        let mutableAttributedString = NSMutableAttributedString(string: currentText, attributes: [
            .font: fontStyle?.font ?? UIFont.systemFont(ofSize: 13),
            .foregroundColor: defaultColor ?? .gray70
        ])

        links.forEach { text, url in
            if let range = currentText.range(of: text) {
                let nsRange = NSRange(range, in: currentText)
                mutableAttributedString.addAttributes([
                    .link: url,
                    .underlineStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: linkColor ?? .gray50
                ], range: nsRange)
            }
        }
        
        self.attributedText = mutableAttributedString
        self.linkTextAttributes = [
            .foregroundColor: linkColor ?? .gray50,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        self.isScrollEnabled = false
        self.isSelectable = true
        self.isEditable = false
        self.dataDetectorTypes = .link
    }
}
