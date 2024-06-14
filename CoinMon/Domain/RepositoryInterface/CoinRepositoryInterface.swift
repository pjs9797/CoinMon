import RxSwift

protocol CoinRepositoryInterface {
    func fetchCoinPriceAtHome(exchange: String) -> Observable<[CoinPriceAtHome]>
    func fetchCoinPriceAtAlarm(exchange: String) -> Observable<[CoinPriceAtAlarm]>
    func fetchCoinFee() -> Observable<[CoinFee]>
}
