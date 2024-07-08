import RxSwift

class CoinUseCase {
    private let repository: CoinRepositoryInterface
    
    init(repository: CoinRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchCoinsPriceListAtHome(market: String) -> Observable<[CoinPrice]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinsPriceAtHome(exchange: marketUpper)
            .map { CoinPriceTranslator.toPriceListsAtHome(dto: $0) }
    }
    
    func fetchCoinsPriceListAtAlarm(market: String) -> Observable<[OneCoinPrice]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinsPriceAtAlarm(exchange: marketUpper)
            .map { CoinPriceTranslator.toPriceListsAtAlarm(dto: $0) }
    }
    
    func fetchOneCoinPrice(market: String, symbol: String) -> Observable<OneCoinPrice> {
        let marketUpper = market.uppercased()
        return repository.fetchOneCoinPrice(exchange: marketUpper, symbol: symbol)
            .map { CoinPriceTranslator.toOnePriceListsAtAlarm(dto: $0) }
    }
    
    func fetchCoinFeeList(market: String) -> Observable<[CoinFee]> {
        let marketUpper = market.uppercased()
        return repository.fetchCoinFee(exchange: marketUpper)
            .map { CoinPriceTranslator.toFeeList(dto: $0) }
    }
    
    func fetchCoinPremiumList(departureMarket: String, arrivalMarket: String) -> Observable<[CoinPremium]> {
        let departureMarketUpper = departureMarket.uppercased()
        let arrivalMarketUpper = arrivalMarket.uppercased()
        return Observable.zip(
            repository.fetchCoinPremiumList(departureExchange: departureMarketUpper, arrivalExchange: arrivalMarketUpper),
            repository.fetchExchangeRate()
        )
        .map { (prices, exchangeRate) in
            let (departureDTO, arrivalDTO) = prices
            let departurePrices = CoinPriceTranslator.toPremiumLists(dto: departureDTO)
            let arrivalPrices = CoinPriceTranslator.toPremiumLists(dto: arrivalDTO)
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
                    let premium = CoinPremium(coinTitle: departurePrice.coinTitle, premium: String(format: "%.2f", premiumValue))
                    premiums.append(premium)
                }
            }
            return premiums
        }
    }
}
