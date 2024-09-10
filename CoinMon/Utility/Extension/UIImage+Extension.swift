import UIKit

extension UIImage {
    func resizeTo20() -> UIImage? {
        let size = CGSize(width: 20*ConstantsManager.standardHeight, height: 20*ConstantsManager.standardHeight)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
