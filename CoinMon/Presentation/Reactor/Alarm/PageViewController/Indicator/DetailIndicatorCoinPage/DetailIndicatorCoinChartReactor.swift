import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class DetailIndicatorCoinChartReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    init(market: String, coin: String){
        self.action.onNext(.updateData(market, coin))
    }
    
    enum Action {
        case updateData(String, String)
    }
    
    enum Mutation {
        case setData(String, String)
    }
    
    struct State {
        var urlString: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateData(let market, let coin):
            let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
            let coinTitle = coin+unit
            return .just(.setData(market, coinTitle))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setData(let market, let coin):
            newState.urlString = generateTradingViewHTML(market: market, coin: coin)
        }
        return newState
    }
    
    private func generateTradingViewHTML(market: String, coin: String) -> String {
        return """
            <!-- TradingView Widget BEGIN -->
            <div class="tradingview-widget-container" style="height:100%;width:100%">
              <div class="tradingview-widget-container__widget" style="height:calc(100% - 32px);width:100%"></div>
              <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/" rel="noopener nofollow" target="_blank"><span class="blue-text">Track all markets on TradingView</span></a></div>
              <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js" async>
              {
              "autosize": true,
              "symbol": "\(market):\(coin)",
              "interval": "D",
              "timezone": "Etc/UTC",
              "theme": "light",
              "style": "1",
              "locale": "en",
              "allow_symbol_change": true,
              "save_image": false,
              "calendar": false,
              "support_host": "https://www.tradingview.com"
            }
              </script>
            </div>
            <!-- TradingView Widget END -->
            """
    }
}
