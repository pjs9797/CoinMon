import UIKit
import WebKit
import ReactorKit

class DetailIndicatorCoinChartViewController: UIViewController, ReactorKit.View, WKNavigationDelegate {
    var disposeBag = DisposeBag()
    let detailIndicatorCoinChartView = DetailIndicatorCoinChartView()
    
    init(with reactor: DetailIndicatorCoinChartReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = detailIndicatorCoinChartView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorManager.common_100
        detailIndicatorCoinChartView.chartWebView.navigationDelegate = self
    }
}

extension DetailIndicatorCoinChartViewController {
    func bind(reactor: DetailIndicatorCoinChartReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: DetailIndicatorCoinChartReactor){
    }
    
    func bindState(reactor: DetailIndicatorCoinChartReactor){
        reactor.state.compactMap { $0.urlString }
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] htmlString in
                self?.detailIndicatorCoinChartView.chartWebView.loadHTMLString(htmlString, baseURL: URL(string: "https://www.tradingview.com"))
            })
            .disposed(by: disposeBag)
    }
}
