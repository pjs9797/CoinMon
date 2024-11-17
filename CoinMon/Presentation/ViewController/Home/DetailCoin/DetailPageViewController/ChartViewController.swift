import UIKit
import WebKit
import ReactorKit

class ChartViewController: UIViewController, ReactorKit.View, WKNavigationDelegate {
    var disposeBag = DisposeBag()
    let chartView = ChartView()
    
    init(with reactor: ChartReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = chartView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        chartView.chartWebView.navigationDelegate = self
    }
}

extension ChartViewController {
    func bind(reactor: ChartReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: ChartReactor){
    }
    
    func bindState(reactor: ChartReactor){
        reactor.state.compactMap { $0.urlString }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] htmlString in
                self?.chartView.chartWebView.loadHTMLString(htmlString, baseURL: URL(string: "https://www.tradingview.com"))
            })
            .disposed(by: disposeBag)
    }
}
