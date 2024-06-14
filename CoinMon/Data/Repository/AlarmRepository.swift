import Moya
import RxMoya
import RxSwift

class AlarmRepository: AlarmRepositoryInterface {
    private let provider = MoyaProvider<AlarmService>()
    
    func createAlarm(exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<String> {
        return provider.rx.request(.createAlarm(exchange: exchange, symbol: symbol, targetPrice: targetPrice, frequency: frequency, useYn: useYn, filter: filter))
            .filterSuccessfulStatusCodes()
            .map(AlarmDTO.self)
            .map{ AlarmDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func deleteAlarm(pushId: Int) -> Observable<String> {
        return provider.rx.request(.deleteAlarm(pushId: pushId))
            .filterSuccessfulStatusCodes()
            .map(AlarmDTO.self)
            .map{ AlarmDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func updateAlarm(pushId: Int, exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<String> {
        return provider.rx.request(.updateAlarm(pushId: pushId, exchange: exchange, symbol: symbol, targetPrice: targetPrice, frequency: frequency, useYn: useYn, filter: filter))
            .filterSuccessfulStatusCodes()
            .map(AlarmDTO.self)
            .map{ AlarmDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func getAlarms() -> Observable<[Alarm]> {
        return provider.rx.request(.getAlarms)
            .filterSuccessfulStatusCodes()
            .map(AlarmResponseDTO.self)
            .map{ AlarmResponseDTO.toAlarms(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
