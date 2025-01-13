import UIKit
import RxSwift
import SnapKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorManager.common_100
    }
    // 기본 네비게이션 타이틀 설정
    func setNavigationBar(title: String?, fontStyle: FontStyle = FontManagerA.H4_16, color: UIColor? = ColorManager.common_0, leftItem: UIBarButtonItem?, rightItem: UIBarButtonItem?) {
        let titleLabel = BaseLabel()
        titleLabel.setStyle(text: title ?? "", fontStyle: fontStyle)
        titleLabel.textColor = color
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = leftItem
        if let leftButton = self.navigationItem.leftBarButtonItem,
           let image = leftButton.image?.withRenderingMode(.alwaysOriginal) {
            leftButton.image = image
        }
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    // 두 번째 스타일: 타이틀과 서브 타이틀 설정
    func setNavigationBarTitleWithSubtitle(title: String, rightBarButton: UIBarButtonItem, titleFont: FontStyle = FontManagerA.D3_22, titleColor: UIColor? = ColorManager.common_0, subtitleFont: FontStyle = FontManagerA.B3_16, subtitleColor: UIColor? = ColorManager.gray_40) {
        // 타이틀 라벨
        let titleLabel = BaseLabel()
        titleLabel.setStyle(text: title, fontStyle: titleFont)
        titleLabel.textColor = titleColor

        // 서브 타이틀 라벨
        let attributes: [NSAttributedString.Key: Any] = [
            .font: subtitleFont.font,
            .foregroundColor: subtitleColor ?? .gray
        ]
        rightBarButton.setTitleTextAttributes(attributes, for: .normal)
                
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // 네비게이션 바의 왼쪽 아이템 설정
    func setLeftNavigationItem(image: UIImage?, action: Selector?) {
        let leftButton = UIButton(type: .system)
        leftButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.tintColor = ColorManager.common_0
        if let action = action {
            leftButton.addTarget(self, action: action, for: .touchUpInside)
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    // 네비게이션 바의 오른쪽 아이템 설정
    func setRightNavigationItem(image: UIImage?, action: Selector?) {
        let rightButton = UIButton(type: .system)
        rightButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton.tintColor = ColorManager.common_0
        if let action = action {
            rightButton.addTarget(self, action: action, for: .touchUpInside)
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
}

//extension BaseViewController: UIGestureRecognizerDelegate{
//    func hideKeyboard(disposeBag: DisposeBag) {
//        let tapGesture = UITapGestureRecognizer()
//        tapGesture.cancelsTouchesInView = false
//        tapGesture.delegate = self
//        view.addGestureRecognizer(tapGesture)
//        
//        tapGesture.rx.event.bind { [weak self] _ in
//            self?.view.endEditing(true)
//        }.disposed(by: disposeBag)
//    }
//    
//    func bindKeyboardToButton(to button: UIButton, disposeBag: DisposeBag) {
//        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
//            .compactMap { $0.userInfo }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self, weak button] userInfo in
//                if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
//                   let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
//                    let keyboardHeight = keyboardFrame.height
//                    let safeAreaBottom = self?.view.safeAreaInsets.bottom
//                    
//                    UIView.animate(withDuration: duration) {
//                        button?.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+(safeAreaBottom ?? 0))
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
//        
//        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
//            .compactMap { $0.userInfo }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak button] userInfo in
//                if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
//                    UIView.animate(withDuration: duration) {
//                        button?.transform = .identity
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    func bindKeyboardToCollectionView(to collectionView: UICollectionView, disposeBag: DisposeBag) {
//        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
//            .compactMap { $0.userInfo }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self, weak collectionView] userInfo in
//                if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
//                   let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
//                    let keyboardHeight = keyboardFrame.height
//                    let safeAreaBottom = self?.view.safeAreaInsets.bottom
//                    
//                    UIView.animate(withDuration: duration) {
//                        collectionView?.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+(safeAreaBottom ?? 0))
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
//        
//        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
//            .compactMap { $0.userInfo }
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak collectionView] userInfo in
//                if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
//                    UIView.animate(withDuration: duration) {
//                        collectionView?.transform = .identity
//                    }
//                }
//            })
//            .disposed(by: disposeBag)
//    }
//}
