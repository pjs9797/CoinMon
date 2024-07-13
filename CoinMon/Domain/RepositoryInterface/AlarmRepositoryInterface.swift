import RxSwift

protocol AlarmRepositoryInterface {
    func createAlarm(exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<String>
    func deleteAlarm(pushId: Int) -> Observable<String>
    func updateAlarm(pushId: Int, exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<String>
    func fetchAlarmList() -> Observable<[Alarm]>
}
