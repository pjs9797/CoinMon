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
    
    func getIndicatorCoinData() -> Observable<[IndicatorCoinData]> {
        return provider.rx.request(.getIndicatorPush)
            .filterSuccessfulStatusCodes()
            .map(GetIndicatorCoinDataResponseDTO.self)
            .map{ GetIndicatorCoinDataResponseDTO.toIndicatorCoinData(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func getIndicatorCoinDataDetail(indicatorId: String) -> Observable<[IndicatorCoinData]> {
        return provider.rx.request(.getIndicatorPushDetail(indicatorId: indicatorId))
            .filterSuccessfulStatusCodes()
            .map(GetIndicatorCoinDataResponseDTO.self)
            .map{ GetIndicatorCoinDataResponseDTO.toIndicatorCoinData(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func getUpdateIndicatorCoinDataDetail(indicatorId: String) -> Observable<[UpdateSelectedIndicatorCoin]> {
        return provider.rx.request(.getIndicatorPushDetail(indicatorId: indicatorId))
            .filterSuccessfulStatusCodes()
            .map(GetIndicatorCoinDetailDataResponseDTO.self)
            .map{ GetIndicatorCoinDetailDataResponseDTO.toUpdateIndicatorCoinData(dto: $0) }
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
    
    func updateIndicatorPush(indicatorId: String, frequency: String, targets: [String]) -> Observable<String> {
        return provider.rx.request(.updateIndicatorPush(indicatorId: indicatorId, frequency: frequency, targets: targets))
            .filterSuccessfulStatusCodes()
            .map(IndicatorDTO.self)
            .map{ IndicatorDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func updateIndicatorPushState(indicatorId: String, isOn: String) -> Observable<String> {
        return provider.rx.request(.updateIndicatorPushState(indicatorId: indicatorId, isOn: isOn))
            .filterSuccessfulStatusCodes()
            .map(IndicatorDTO.self)
            .map{ IndicatorDTO.toResultCode(dto: $0) }
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
    
    func getIndicatorCoinHistory(indicatorId: String, indicatorCoinId: String) -> Observable<[IndicatorCoinHistory]> {
        return provider.rx.request(.getIndicatorCoinHistory(indicatorId: indicatorId, indicatorCoinId: indicatorCoinId))
            .filterSuccessfulStatusCodes()
            .map(GetIndicatorCoinHistoryResponseDTO.self)
            .map{ GetIndicatorCoinHistoryResponseDTO.toIndicatorCoinHistory(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func deleteIndicatorPush(indicatorId: String) -> Observable<String> {
        return provider.rx.request(.deleteIndicatorPush(indicatorId: indicatorId))
            .filterSuccessfulStatusCodes()
            .map(IndicatorDTO.self)
            .map{ IndicatorDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
