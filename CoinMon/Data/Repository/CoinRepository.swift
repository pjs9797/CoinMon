import Moya
import RxMoya
import RxSwift

class CoinRepository: CoinRepositoryInterface {
    private let provider = MoyaProvider<CoinService>()
    
    func fetchCoinsPriceAtHome(exchange: String) -> Observable<[CoinPrice]> {
        return provider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toPriceListsAtHome(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinsPriceAtAlarm(exchange: String) -> Observable<[OneCoinPrice]> {
        return provider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toPriceListsAtAlarm(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchOneCoinPrice(exchange: String, symbol: String) -> Observable<OneCoinPrice> {
        return provider.rx.request(.getOneCoinData(exchange: exchange, symbol: symbol))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toOnePriceListsAtAlarm(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinFee(exchange: String) -> Observable<[CoinFee]> {
        return provider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toFeeList(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinPremiumList(departureExchange: String, arrivalExchange: String) -> Observable<(departurePrices: [OneCoinPrice], arrivalPrices: [OneCoinPrice])> {
        let departureObservable = provider.rx.request(.getCoinData(exchange: departureExchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toPriceListsAtAlarm(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
        
        let arrivalObservable = provider.rx.request(.getCoinData(exchange: arrivalExchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toPriceListsAtAlarm(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
        
        return Observable.zip(departureObservable, arrivalObservable)
            .map { (departurePrices: $0.0, arrivalPrices: $0.1) }
    }
}
