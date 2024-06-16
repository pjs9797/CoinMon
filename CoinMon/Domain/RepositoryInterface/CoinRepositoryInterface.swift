import RxSwift

protocol CoinRepositoryInterface {
    func fetchCoinsPriceAtHome(exchange: String) -> Observable<[CoinPrice]>
    func fetchCoinsPriceAtAlarm(exchange: String) -> Observable<[OneCoinPrice]>
    func fetchOneCoinPrice(exchange: String, symbol: String) -> Observable<OneCoinPrice>
    func fetchCoinFee(exchange: String) -> Observable<[CoinFee]>
    func fetchCoinPremiumList(departureExchange: String, arrivalExchange: String) -> Observable<(departurePrices: [OneCoinPrice], arrivalPrices: [OneCoinPrice])> 
}
