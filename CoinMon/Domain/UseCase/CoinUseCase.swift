import RxSwift
import Foundation

class CoinUseCase {
    private let repository: CoinRepositoryInterface

    init(repository: CoinRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchCoinPriceList() -> Observable<[CoinPriceAtHome]> {
        return repository.fetchCoinPriceList()
    }
    func fetchCoinFeeList() -> Observable<[CoinFee]> {
        return repository.fetchCoinFeeList()
    }
}
