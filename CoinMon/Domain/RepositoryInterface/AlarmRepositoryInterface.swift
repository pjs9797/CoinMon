import RxSwift

protocol AlarmRepositoryInterface {
    func createAlarm(exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<AlarmDTO>
    func deleteAlarm(pushId: Int) -> Observable<AlarmDTO>
    func updateAlarm(pushId: Int, exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<AlarmDTO>
    func getAlarms() -> Observable<AlarmResponseDTO>
}
