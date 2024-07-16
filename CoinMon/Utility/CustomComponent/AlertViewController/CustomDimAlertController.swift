import UIKit

class CustomDimAlertController: UIAlertController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let dimmingView = self.view.superview?.subviews.first(where: { $0.isUserInteractionEnabled }) {
            UIView.transition(with: dimmingView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            }, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let dimmingView = self.view.superview?.subviews.first(where: { $0.isUserInteractionEnabled }) {
            UIView.transition(with: dimmingView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                dimmingView.backgroundColor = UIColor.clear
            }, completion: nil)
        }
    }
}

