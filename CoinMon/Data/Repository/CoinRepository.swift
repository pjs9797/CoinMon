import Moya
import RxMoya
import RxSwift

class CoinRepository: CoinRepositoryInterface {
    private let provider = MoyaProvider<CoinService>()
    
    func fetchCoinPriceList() -> Observable<[CoinPriceAtHome]> {
        return provider.rx.request(.getCoinData)
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toPriceLists(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinFeeList() -> Observable<[CoinFee]> {
        return Observable.just([])
    }
}
