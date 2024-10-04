import Moya
import RxMoya
import RxSwift

class CoinRepository: CoinRepositoryInterface {
    private let coinProvider = MoyaProvider<CoinService>()
    private let exchangeRateProvider = MoyaProvider<ExchangeRateService>()
    
    func fetchCoinPriceChangeGapList(exchange: String) -> Observable<[CoinPriceChangeGap]> {
        return coinProvider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toCoinPriceChangeGapList(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinFeeList(exchange: String) -> Observable<[CoinFee]> {
        return coinProvider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toCoinFeeList(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinPremiumList(departureExchange: String, arrivalExchange: String) -> Observable<(departurePrices: [CoinPrice], arrivalPrices: [CoinPrice])> {
        let departureObservable = coinProvider.rx.request(.getCoinData(exchange: departureExchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toCoinPriceListForPremium(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
        
        let arrivalObservable = coinProvider.rx.request(.getCoinData(exchange: arrivalExchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toCoinPriceListForPremium(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
        
        return Observable.zip(departureObservable, arrivalObservable)
            .map { (departurePrices: $0.0, arrivalPrices: $0.1) }
    }
    
    func fetchCoinPriceForSelectCoinsAtAlarm(exchange: String) -> Observable<[CoinPrice]> {
        return coinProvider.rx.request(.getCoinData(exchange: exchange))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toCoinPriceListForSelectCoinsAtAlarm(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchOnlyOneCoinPrice(exchange: String, symbol: String) -> Observable<CoinPrice> {
        return coinProvider.rx.request(.getOneCoinData(exchange: exchange, symbol: symbol))
            .filterSuccessfulStatusCodes()
            .map(CoinPriceResponseDTO.self)
            .map { CoinPriceResponseDTO.toCoinPrice(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
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
    
    func fetchCoinDetailBaseInfo(exchange: String, symbol: String) -> Observable<DetailBasicInfo> {
        return coinProvider.rx.request(.getCoinDetail(exchange: exchange, symbol: symbol))
            .filterSuccessfulStatusCodes()
            .map(CoinDetailResponseDTO.self)
            .map { CoinDetailResponseDTO.toDetailBasicInfo(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchCoinDetailPriceInfo(exchange: String, symbol: String) -> Observable<DetailPriceInfo> {
        return coinProvider.rx.request(.getCoinDetail(exchange: exchange, symbol: symbol))
            .filterSuccessfulStatusCodes()
            .map(CoinDetailResponseDTO.self)
            .map { CoinDetailResponseDTO.toDetailPriceInfo(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
