import RxSwift

class CoinUseCase {
    private let repository: CoinRepositoryInterface

    init(repository: CoinRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchCoinPriceList(exchange: String) -> Observable<[CoinPriceAtHome]> {
        let exchangeUpper = exchange.uppercased()
        return repository.fetchCoinPriceAtHome(exchange: exchangeUpper)
    }
    
    func fetchCoinPriceAtAlarm(exchange: String) -> Observable<[CoinPriceAtAlarm]> {
        let exchangeUpper = exchange.uppercased()
        return repository.fetchCoinPriceAtAlarm(exchange: exchangeUpper)
    }
    
    func fetchCoinFeeList() -> Observable<[CoinFee]> {
        return repository.fetchCoinFee()
    }
}
