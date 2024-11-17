import UIKit
import SnapKit

class MainIndicatorView: UIView {
    let subscriptionIndicatorView = SubscriptionIndicatorView()
    let normalNoneIndicatorView = NormalNoneIndicatorView()
    let subscriptionNoneIndicatorView = SubscriptionNoneIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(view: UIView) {
        [normalNoneIndicatorView, subscriptionNoneIndicatorView, subscriptionIndicatorView].forEach { $0.isHidden = true }
        view.isHidden = false
    }
    
    func setLocalizedText(){
        subscriptionIndicatorView.setLocalizedText()
        normalNoneIndicatorView.setLocalizedText()
        subscriptionNoneIndicatorView.setLocalizedText()
    }
    
    private func layout() {
        [subscriptionIndicatorView,normalNoneIndicatorView,subscriptionNoneIndicatorView]
            .forEach{
                addSubview($0)
            }
        
        subscriptionIndicatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        normalNoneIndicatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
        subscriptionNoneIndicatorView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
