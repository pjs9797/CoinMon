import Moya
import RxMoya
import RxSwift

class AlarmRepository: AlarmRepositoryInterface {
    private let provider = MoyaProvider<AlarmService>()
    
    func createAlarm(exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<AlarmDTO> {
        return provider.rx.request(.createAlarm(exchange: exchange, symbol: symbol, targetPrice: targetPrice, frequency: frequency, useYn: useYn, filter: filter))
            .filterSuccessfulStatusCodes()
            .map(AlarmDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func deleteAlarm(pushId: Int) -> Observable<AlarmDTO> {
        return provider.rx.request(.deleteAlarm(pushId: pushId))
            .filterSuccessfulStatusCodes()
            .map(AlarmDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func updateAlarm(pushId: Int, exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<AlarmDTO> {
        return provider.rx.request(.updateAlarm(pushId: pushId, exchange: exchange, symbol: symbol, targetPrice: targetPrice, frequency: frequency, useYn: useYn, filter: filter))
            .filterSuccessfulStatusCodes()
            .map(AlarmDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func getAlarms() -> Observable<AlarmResponseDTO> {
        return provider.rx.request(.getAlarms)
            .filterSuccessfulStatusCodes()
            .map(AlarmResponseDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
