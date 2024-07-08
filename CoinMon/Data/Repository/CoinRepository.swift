import Moya
import RxMoya
import RxSwift

class CoinRepository: CoinRepositoryInterface {
    private let coinProvider = MoyaProvider<CoinService>()
    private let exchangeRateProvider = MoyaProvider<ExchangeRateService>()
    
    func fetchCoinsPriceAtHome(exchange: String) -> Observable<CoinPriceResponseDTO> {
        return coinProvider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinsPriceAtAlarm(exchange: String) -> Observable<CoinPriceResponseDTO> {
        return coinProvider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchOneCoinPrice(exchange: String, symbol: String) -> Observable<CoinPriceResponseDTO> {
        return coinProvider.rx.request(.getOneCoinData(exchange: exchange, symbol: symbol))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinFee(exchange: String) -> Observable<CoinPriceResponseDTO> {
        return coinProvider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinPremiumList(departureExchange: String, arrivalExchange: String) -> Observable<(departureDTO: CoinPriceResponseDTO, arrivalDTO: CoinPriceResponseDTO)> {
        let departureObservable = coinProvider.rx.request(.getCoinData(exchange: departureExchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
        
        let arrivalObservable = coinProvider.rx.request(.getCoinData(exchange: arrivalExchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
        
        return Observable.zip(departureObservable, arrivalObservable)
            .map { (departureDTO: $0.0, arrivalDTO: $0.1) }
    }
    
    func fetchExchangeRate() -> Observable<Double> {
        return exchangeRateProvider.rx.request(.getLatestRates)
            .filterSuccessfulStatusCodes()
            .map(ExchangeRateResponse.self)
            .map { response in
                return response.usdt["krw"] ?? 0.0
            }
            .asObservable()
    }
}
