import UIKit
import WebKit
import SnapKit

class ChartView: UIView {
    let chartWebView = WKWebView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(chartWebView)
        
        chartWebView.snp.makeConstraints { make in
            make.height.equalTo(524*ConstantsManager.standardHeight)
            make.leading.top.trailing.equalToSuperview()
        }
    }
}
