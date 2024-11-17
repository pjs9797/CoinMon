import UIKit

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        
        // 네비게이션 바의 타이틀 텍스트 속성 설정
        let attributes = [NSAttributedString.Key.font: FontManager.H4_16]
        navigationBar.titleTextAttributes = attributes
        navigationBar.tintColor = ColorManager.common_0
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 뒤로가기 제스처는 네비게이션 스택에 2개 이상의 뷰 컨트롤러가 있을 때만 활성화
        return viewControllers.count > 1
    }
    
    /// 커스텀 애니메이션으로 화면을 push
    public func pushUpWithAnimation(viewController: UIViewController) {
        // CATransition을 사용해 애니메이션 정의
        let transition = CATransition()
        transition.duration = 0.5 // 애니메이션 지속 시간 설정 (0.3초)
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut) // 애니메이션 가속 설정
        transition.type = .moveIn // 새 뷰가 현재 뷰 위로 들어오는 방식
        transition.subtype = .fromTop // 화면이 위에서 아래로 이동
        
        // 네비게이션 컨트롤러의 레이어에 애니메이션 적용
        self.view.layer.add(transition, forKey: kCATransition)
        
        // 애니메이션 없이 push 수행 (애니메이션은 CATransition이 처리)
        DispatchQueue.main.async {
            self.pushViewController(viewController, animated: false)
        }
    }
    
    /// 커스텀 애니메이션으로 화면을 pop
    public func popDownWithAnimation() {
        // CATransition을 사용해 애니메이션 정의
        let transition = CATransition()
        transition.duration = 0.3 // 애니메이션 지속 시간 설정 (0.3초)
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut) // 애니메이션 가속 설정
        transition.type = .reveal // 기존 뷰가 새로운 뷰 위로 내려가는 방식
        transition.subtype = .fromBottom // 화면이 아래로 이동
        
        // 네비게이션 컨트롤러의 레이어에 애니메이션 적용
        self.view.layer.add(transition, forKey: kCATransition)
        
        // 애니메이션 없이 pop 수행 (애니메이션은 CATransition이 처리)
        DispatchQueue.main.async {
            self.popViewController(animated: false)
        }
    }
}
