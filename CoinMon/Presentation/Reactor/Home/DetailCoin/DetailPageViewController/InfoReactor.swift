import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class InfoReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    let coinUseCase: CoinUseCase
    
    init(coinUseCase: CoinUseCase, market: String, coin: String){
        self.coinUseCase = coinUseCase
        //TODO: market 변경
        self.initialState = State(market: "Bithumb", coin: "ONDO", coinTitle: "\(coin)•\(LocalizationManager.shared.localizedString(forKey: market))")
    }
    
    enum Action {
        case setCoinDetailPriceInfo
    }
    
    enum Mutation {
        case setHighPrice(String)
        case setLowPrice(String)
        case setPriceChangeList([PriceChange])
    }
    
    struct State {
        var market: String
        var coin: String
        var coinTitle: String
        var highPrice: String = ""
        var lowPrice: String = ""
        var priceChangeList: [PriceChange] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setCoinDetailPriceInfo:
            return Observable.zip(
                self.coinUseCase.fetchCoinDetailPriceInfo(exchange: currentState.market, symbol: currentState.coin),
                self.coinUseCase.fetchOnlyOneCoinPrice(market: currentState.market, symbol: currentState.coin)
            )
            .flatMap { [weak self] (detailPriceInfo, currentCoinPrice) -> Observable<Mutation> in
                let currencySymbol = self?.currentState.market == "Upbit" || self?.currentState.market == "Bithumb" ? "₩" : "$"
                
                let highFormatter = NumberFormatter()
                highFormatter.numberStyle = .decimal
                highFormatter.maximumFractionDigits = self?.getDecimalPlaces(detailPriceInfo.lowHighPrice.high) ?? 0
                var highPrice = highFormatter.string(from: NSNumber(value: Double(detailPriceInfo.lowHighPrice.high) ?? 0)) ?? detailPriceInfo.lowHighPrice.high
                highPrice = "\(currencySymbol) \(highPrice)"
                
                let lowFormatter = NumberFormatter()
                lowFormatter.numberStyle = .decimal
                lowFormatter.maximumFractionDigits = self?.getDecimalPlaces(detailPriceInfo.lowHighPrice.low) ?? 0
                var lowPrice = lowFormatter.string(from: NSNumber(value: Double(detailPriceInfo.lowHighPrice.low) ?? 0)) ?? detailPriceInfo.lowHighPrice.low
                lowPrice = "\(currencySymbol) \(lowPrice)"
                
                let currentPrice = Double(currentCoinPrice.price) ?? 0
                let historicalPrices = detailPriceInfo.historicalPrices
                
                let priceChanges = [
                    self?.calculatePriceChange(title: "24시간", current: currentPrice, historical: historicalPrices.lastPrice1),
                    self?.calculatePriceChange(title: "7일", current: currentPrice, historical: historicalPrices.lastPrice7),
                    self?.calculatePriceChange(title: "30일", current: currentPrice, historical: historicalPrices.lastPrice30),
                    self?.calculatePriceChange(title: "90일", current: currentPrice, historical: historicalPrices.lastPrice90),
                    self?.calculatePriceChange(title: "1년", current: currentPrice, historical: historicalPrices.lastPrice365)
                ].compactMap { $0 }
                
                return Observable.concat([
                    .just(.setHighPrice(highPrice)),
                    .just(.setLowPrice(lowPrice)),
                    .just(.setPriceChangeList(priceChanges))
                ])
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setHighPrice(let price):
            newState.highPrice = price
        case .setLowPrice(let price):
            newState.lowPrice = price
        case .setPriceChangeList(let list):
            newState.priceChangeList = list
        }
        return newState
    }
    
    private func getDecimalPlaces(_ number: String) -> Int {
        let components = number.components(separatedBy: ".")
        return components.count > 1 ? components[1].count : 0
    }
    
    private func calculatePriceChange(title: String, current: Double, historical: String) -> PriceChange {
        let historicalPrice = Double(historical) ?? 0
        var basePrice: Double = 0
        var change: Double = 0
        var roundedChange: Double = 0
        if historicalPrice == 0 {
            roundedChange = 1000000000
        }
        else {
            basePrice = historicalPrice
            change = ((current - basePrice) / basePrice) * 100
            roundedChange = (change * 100).rounded() / 100
        }
        return PriceChange(title: LocalizationManager.shared.localizedString(forKey: title), priceChange: roundedChange)
    }
}
