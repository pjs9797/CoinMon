import RxSwift

class CoinUseCase {
    private let repository: CoinRepositoryInterface
    
    init(repository: CoinRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchCoinPriceChangeGapList(market: String) -> Observable<[CoinPriceChangeGap]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinPriceChangeGapList(exchange: marketUpper)
            .map { $0.sorted { Double($0.price) ?? 0 > Double($1.price) ?? 0 } }
    }
    
    func fetchCoinFeeList(market: String) -> Observable<[CoinFee]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinFeeList(exchange: marketUpper)
            .map { $0.sorted { $0.price > $1.price } }
    }
    
    func fetchCoinPremiumList(departureMarket: String, arrivalMarket: String) -> Observable<[CoinPremium]> {
        let departureMarketUpper = departureMarket.uppercased()
        let arrivalMarketUpper = arrivalMarket.uppercased()
        return Observable.zip(
            repository.fetchCoinPremiumList(departureExchange: departureMarketUpper, arrivalExchange: arrivalMarketUpper),
            repository.fetchExchangeRate()
        )
        .map { (prices, exchangeRate) in
            let (departurePrices, arrivalPrices) = prices
            var premiums: [CoinPremium] = []
            for departurePrice in departurePrices {
                if let arrivalPrice = arrivalPrices.first(where: { $0.coinTitle == departurePrice.coinTitle }) {
                    let krwPrice = Double(departurePrice.price) ?? 0.0
                    let usdtPrice = Double(arrivalPrice.price) ?? 0.0
                    let usdtPriceInKRW = usdtPrice * exchangeRate
                    let premiumValue = ((krwPrice - usdtPriceInKRW) / usdtPriceInKRW) * 100
                    if departurePrice.coinTitle == "TON" {
                        continue
                    }
                    let premium = CoinPremium(coinTitle: departurePrice.coinTitle, premium: String(format: "%.2f", premiumValue), price: krwPrice)
                    premiums.append(premium)
                }
            }
            return premiums.sorted { $0.price > $1.price }
        }
    }
    
    func fetchCoinPriceForSelectCoinsAtAlarm(market: String) -> Observable<[CoinPrice]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinPriceForSelectCoinsAtAlarm(exchange: marketUpper)
            .map { $0.sorted { Double($0.price) ?? 0 > Double($1.price) ?? 0 } }
    }
    
    func fetchOnlyOneCoinPrice(market: String, symbol: String) -> Observable<CoinPrice> {
        let marketUpper = market.uppercased()
        return repository.fetchOnlyOneCoinPrice(exchange: marketUpper, symbol: symbol)
    }
}
