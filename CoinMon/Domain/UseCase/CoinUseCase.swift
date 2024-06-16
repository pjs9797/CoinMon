import RxSwift

class CoinUseCase {
    private let repository: CoinRepositoryInterface
    
    init(repository: CoinRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchCoinsPriceListAtHome(market: String) -> Observable<[CoinPrice]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinsPriceAtHome(exchange: marketUpper)
    }
    
    func fetchCoinsPriceListAtAlarm(market: String) -> Observable<[OneCoinPrice]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinsPriceAtAlarm(exchange: marketUpper)
    }
    
    func fetchOneCoinPrice(market: String, symbol: String) -> Observable<OneCoinPrice> {
        let marketUpper = market.uppercased()
        return repository.fetchOneCoinPrice(exchange: marketUpper, symbol: symbol)
    }
    
    func fetchCoinFeeList(market: String) -> Observable<[CoinFee]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinFee(exchange: marketUpper)
    }
    
    func fetchCoinPremiumList(departureMarket: String, arrivalMarket: String) -> Observable<[CoinPremium]> {
        let departureMarketUpper = departureMarket.uppercased()
        let arrivalMarketUpper = arrivalMarket.uppercased()
        return repository.fetchCoinPremiumList(departureExchange: departureMarketUpper, arrivalExchange: arrivalMarketUpper)
            .map { (departurePrices, arrivalPrices) in
                var premiums: [CoinPremium] = []
                for departurePrice in departurePrices {
                    if let arrivalPrice = arrivalPrices.first(where: { $0.coinTitle == departurePrice.coinTitle }) {
                        let doubleArrivalPrice = Double(arrivalPrice.price) ?? 0.0
                        let doubleDeparturePrice = Double(departurePrice.price) ?? 1.0
                        let premiumValue = (doubleDeparturePrice / doubleArrivalPrice) / doubleDeparturePrice * 100
                        let premium = CoinPremium(coinTitle: departurePrice.coinTitle, premium: String(format: "%.2f%%", premiumValue))
                        premiums.append(premium)
                    }
                }
                return premiums
            }
    }
}
