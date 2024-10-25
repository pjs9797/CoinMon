import Moya
import RxMoya
import RxSwift

class IndicatorRepository: IndicatorRepositoryInterface {
    private let provider = MoyaProvider<IndicatorService>()
    
    func getIndicator() -> Observable<[GetIndicatorData]> {
        return provider.rx.request(.getIndicator)
            .filterSuccessfulStatusCodes()
            .map(GetIndicatorResponseDTO.self)
            .map{ GetIndicatorResponseDTO.toGetIndicatorDatas(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func getIndicatorPushOnly() -> Observable<[GetIndicatorPush]> {
        return provider.rx.request(.getIndicatorPush)
            .filterSuccessfulStatusCodes()
            .map(GetIndicatorPushResponseDTO.self)
            .map{ GetIndicatorPushResponseDTO.toGetIndicatorPushs(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func getIndicatorCoinList(indicatorId: String) -> Observable<[IndicatorCoinPriceChange]> {
        return provider.rx.request(.getIndicatorCoinList(indicatorId: indicatorId))
            .filterSuccessfulStatusCodes()
            .map(GetIndicatorCoinListResponseDTO.self)
            .map{ GetIndicatorCoinListResponseDTO.toIndicatorCoinPriceChanges(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func createIndicatorPush(indicatorId: String, frequency: String, targets: [String]) -> Observable<String> {
        return provider.rx.request(.createIndicatorPush(indicatorId: indicatorId, frequency: frequency, targets: targets))
            .filterSuccessfulStatusCodes()
            .map(IndicatorDTO.self)
            .map{ IndicatorDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
