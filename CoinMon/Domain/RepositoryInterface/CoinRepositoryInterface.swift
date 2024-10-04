import RxSwift

protocol CoinRepositoryInterface {
    func fetchCoinPriceChangeGapList(exchange: String) -> Observable<[CoinPriceChangeGap]>
    func fetchCoinFeeList(exchange: String) -> Observable<[CoinFee]>
    func fetchCoinPriceForSelectCoinsAtAlarm(exchange: String) -> Observable<[CoinPrice]>
    func fetchOnlyOneCoinPrice(exchange: String, symbol: String) -> Observable<CoinPrice>
    func fetchCoinPremiumList(departureExchange: String, arrivalExchange: String) -> Observable<(departurePrices: [CoinPrice], arrivalPrices: [CoinPrice])>
    func fetchExchangeRate() -> Observable<Double>
    func fetchCoinDetailBaseInfo(exchange: String, symbol: String) -> Observable<DetailBasicInfo>
    func fetchCoinDetailPriceInfo(exchange: String, symbol: String) -> Observable<DetailPriceInfo>
}
