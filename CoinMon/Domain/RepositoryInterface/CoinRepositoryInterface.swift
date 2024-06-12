import RxSwift

protocol CoinRepositoryInterface {
    func fetchCoinPriceList() -> Observable<[CoinPriceAtHome]>
    func fetchCoinFeeList() -> Observable<[CoinFee]>
}
