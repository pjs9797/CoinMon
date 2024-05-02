import UIKit

struct FontManager {
    static let H1_28 = pretendard(.bold, size: 28, lineHeight: 36, letterSpacing: -0.2)
    static let H2_24 = pretendard(.bold, size: 24, lineHeight: 32, letterSpacing: -0.2)
    static let H3_22 = pretendard(.semibold, size: 22, lineHeight: 30, letterSpacing: -0.2)
    static let H4_20 = pretendard(.semibold, size: 20, lineHeight: 28, letterSpacing: -0.3)
    static let H5_18 = pretendard(.semibold, size: 18, lineHeight: 26, letterSpacing: -0.3)
    static let H6_16 = pretendard(.semibold, size: 16, lineHeight: 24, letterSpacing: -0.3)
    static let H7_14 = pretendard(.semibold, size: 14, lineHeight: 22, letterSpacing: -0.3)

    static let T1_20 = pretendard(.medium, size: 20, lineHeight: 28, letterSpacing: -0.3)
    static let T2_18 = pretendard(.medium, size: 18, lineHeight: 26, letterSpacing: -0.3)
    static let T3_16 = pretendard(.medium, size: 16, lineHeight: 24, letterSpacing: -0.3)
    static let T4_14 = pretendard(.medium, size: 14, lineHeight: 22, letterSpacing: -0.3)
    static let T5_12 = pretendard(.medium, size: 12, lineHeight: 18, letterSpacing: -0.1)

    static let B1_20 = pretendard(.regular, size: 20, lineHeight: 28, letterSpacing: -0.3)
    static let B2_18 = pretendard(.regular, size: 18, lineHeight: 26, letterSpacing: -0.3)
    static let B3_16 = pretendard(.regular, size: 16, lineHeight: 24, letterSpacing: -0.3)
    static let B4_14 = pretendard(.regular, size: 14, lineHeight: 22, letterSpacing: -0.3)
    static let B5_12 = pretendard(.regular, size: 12, lineHeight: 18, letterSpacing: -0.1)

    static let C1_10 = pretendard(.regular, size: 10, lineHeight: 14, letterSpacing: -0.1)

    static func pretendard(_ weight: UIFont.Weight, size: CGFloat, lineHeight: CGFloat, letterSpacing: CGFloat) -> UIFont {
        let fontName: String
        switch weight {
        case .bold:
            fontName = "Pretendard-Bold"
        case .semibold:
            fontName = "Pretendard-SemiBold"
        case .medium:
            fontName = "Pretendard-Medium"
        case .regular:
            fontName = "Pretendard-Regular"
        default:
            fontName = "Pretendard-Regular"
        }
        
        let font = UIFont(name: fontName, size: size * Constants.standardWidth) ?? UIFont.systemFont(ofSize: size * Constants.standardWidth)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight * Constants.standardHeight
        paragraphStyle.maximumLineHeight = lineHeight * Constants.standardHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: letterSpacing * Constants.standardWidth,
            .paragraphStyle: paragraphStyle
        ]

        let attributedString = NSAttributedString(string: " ", attributes: attributes)
        return font.withAttributes(attributes)
    }
}
