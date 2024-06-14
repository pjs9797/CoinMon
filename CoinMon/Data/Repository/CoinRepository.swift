import Moya
import RxMoya
import RxSwift

class CoinRepository: CoinRepositoryInterface {
    private let provider = MoyaProvider<CoinService>()
    
    func fetchCoinPriceAtHome(exchange: String) -> Observable<[CoinPriceAtHome]> {
        return provider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toPriceListsAtHome(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinPriceAtAlarm(exchange: String) -> Observable<[CoinPriceAtAlarm]> {
        return provider.rx.request(.getCoinData(exchange: exchange))
            .debug("getCoinData")
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toPriceListsAtAlarm(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinFee() -> Observable<[CoinFee]> {
        return Observable.just([])
    }
}
