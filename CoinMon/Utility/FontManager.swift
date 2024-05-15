import UIKit

struct FontManager {
    static let D1_28 = pretendard(.bold, size: 28, lineHeight: 36, letterSpacing: -0.2)
    static let D2_24 = pretendard(.bold, size: 24, lineHeight: 32, letterSpacing: -0.2)
    static let D3_22 = pretendard(.bold, size: 22, lineHeight: 30, letterSpacing: -0.2)
    static let D4_20 = pretendard(.bold, size: 20, lineHeight: 28, letterSpacing: -0.3)
    static let D5_18 = pretendard(.bold, size: 18, lineHeight: 26, letterSpacing: -0.3)
    static let D6_16 = pretendard(.bold, size: 16, lineHeight: 24, letterSpacing: -0.3)
    static let D7_15 = pretendard(.bold, size: 15, lineHeight: 23, letterSpacing: -0.3)
    static let D8_14 = pretendard(.bold, size: 14, lineHeight: 22, letterSpacing: -0.3)
    static let D9_13 = pretendard(.bold, size: 13, lineHeight: 18, letterSpacing: -0.2)

    static let H1_22 = pretendard(.semibold, size: 22, lineHeight: 30, letterSpacing: -0.2)
    static let H2_20 = pretendard(.semibold, size: 20, lineHeight: 28, letterSpacing: -0.3)
    static let H3_18 = pretendard(.semibold, size: 18, lineHeight: 26, letterSpacing: -0.3)
    static let H4_16 = pretendard(.semibold, size: 16, lineHeight: 24, letterSpacing: -0.3)
    static let H5_15 = pretendard(.semibold, size: 15, lineHeight: 23, letterSpacing: -0.3)
    static let H6_14 = pretendard(.semibold, size: 14, lineHeight: 22, letterSpacing: -0.3)
    static let H6_14_read = pretendard(.semibold, size: 14, lineHeight: 20, letterSpacing: -0.3)
    static let H7_13 = pretendard(.semibold, size: 13, lineHeight: 18, letterSpacing: -0.2)

    static let T1_20 = pretendard(.medium, size: 20, lineHeight: 28, letterSpacing: -0.3)
    static let T2_18 = pretendard(.medium, size: 18, lineHeight: 26, letterSpacing: -0.3)
    static let T3_16 = pretendard(.medium, size: 16, lineHeight: 24, letterSpacing: -0.3)
    static let T4_15 = pretendard(.medium, size: 15, lineHeight: 23, letterSpacing: -0.3)
    static let T5_14 = pretendard(.medium, size: 14, lineHeight: 22, letterSpacing: -0.3)
    static let T5_14_read = pretendard(.medium, size: 14, lineHeight: 20, letterSpacing: -0.3)
    static let T6_13 = pretendard(.medium, size: 13, lineHeight: 18, letterSpacing: -0.2)
    static let T7_12 = pretendard(.medium, size: 12, lineHeight: 18, letterSpacing: 0)
    static let T7_12_read = pretendard(.medium, size: 12, lineHeight: 16, letterSpacing: 0)
    static let T8_10 = pretendard(.medium, size: 10, lineHeight: 14, letterSpacing: 0)

    static let B1_20 = pretendard(.regular, size: 20, lineHeight: 28, letterSpacing: -0.3)
    static let B2_18 = pretendard(.regular, size: 18, lineHeight: 26, letterSpacing: -0.3)
    static let B3_16 = pretendard(.regular, size: 16, lineHeight: 24, letterSpacing: -0.3)
    static let B4_15 = pretendard(.regular, size: 15, lineHeight: 23, letterSpacing: -0.3)
    static let B5_14 = pretendard(.regular, size: 14, lineHeight: 22, letterSpacing: -0.3)
    static let B5_14_read = pretendard(.regular, size: 14, lineHeight: 20, letterSpacing: -0.3)
    static let B6_13 = pretendard(.regular, size: 13, lineHeight: 18, letterSpacing: -0.2)
    static let B7_12 = pretendard(.regular, size: 12, lineHeight: 18, letterSpacing: 0)
    static let B7_12_read = pretendard(.regular, size: 12, lineHeight: 16, letterSpacing: 0)
    static let B8_19 = pretendard(.regular, size: 10, lineHeight: 14, letterSpacing: 0)

    static let C1_10 = pretendard(.regular, size: 10, lineHeight: 14, letterSpacing: 0)

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
