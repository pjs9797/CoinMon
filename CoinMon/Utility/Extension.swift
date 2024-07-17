import UIKit
import RxSwift

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        
        let attributes = [ NSAttributedString.Key.font: FontManager.H4_16 ]

        navigationBar.titleTextAttributes = attributes
        navigationBar.tintColor = ColorManager.common_0
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension UIViewController: UIGestureRecognizerDelegate{
    func hideKeyboard(disposeBag: DisposeBag) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind { [weak self] _ in
            self?.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
    
    func bindKeyboardNotifications(to button: UIButton, disposeBag: DisposeBag) {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self, weak button] userInfo in
                if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                   let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                    let keyboardHeight = keyboardFrame.height
                    let safeAreaBottom = self?.view.safeAreaInsets.bottom
                    
                    UIView.animate(withDuration: duration) {
                        button?.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+(safeAreaBottom ?? 0))
                    }
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .compactMap { $0.userInfo }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak button] userInfo in
                if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                    UIView.animate(withDuration: duration) {
                        button?.transform = .identity
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension UIFont {
    func withAttributes(_ attributes: [NSAttributedString.Key: Any]) -> UIFont {
        let descriptor = self.fontDescriptor.addingAttributes([.init(rawValue: "NSCTFontUIUsageAttribute"): attributes])
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}

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

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: 3*ConstantsManager.standardHeight
        ], range: NSRange(location: 0, length: title.count))
        
        setAttributedTitle(attributedString, for: .normal)
    }
}

extension UITableView {
    func goToMiddle() {
        DispatchQueue.main.async {
            let row = self.numberOfRows(inSection: 0) - 1
            
            let indexPath = IndexPath(row: row/2-3, section: 0)
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}
