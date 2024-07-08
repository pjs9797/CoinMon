import RxSwift

protocol CoinRepositoryInterface {
    func fetchCoinsPriceAtHome(exchange: String) -> Observable<CoinPriceResponseDTO>
    func fetchCoinsPriceAtAlarm(exchange: String) -> Observable<CoinPriceResponseDTO>
    func fetchOneCoinPrice(exchange: String, symbol: String) -> Observable<CoinPriceResponseDTO>
    func fetchCoinFee(exchange: String) -> Observable<CoinPriceResponseDTO>
    func fetchCoinPremiumList(departureExchange: String, arrivalExchange: String) -> Observable<(departureDTO: CoinPriceResponseDTO, arrivalDTO: CoinPriceResponseDTO)>
    func fetchExchangeRate() -> Observable<Double>
}
