import RxSwift

class AlarmUseCase {
    private let repository: AlarmRepositoryInterface

    init(repository: AlarmRepositoryInterface) {
        self.repository = repository
    }
    
    func createAlarm(exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<String> {
        let exchangeUpper = exchange.uppercased()
        return repository.createAlarm(exchange: exchangeUpper, symbol: symbol, targetPrice: targetPrice, frequency: frequency, useYn: useYn, filter: filter)
    }
    
    func deleteAlarm(pushId: Int) -> Observable<String> {
        return repository.deleteAlarm(pushId: pushId)
    }
    
    func updateAlarm(pushId: Int, exchange: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<String> {
        return repository.updateAlarm(pushId: pushId, exchange: exchange, symbol: symbol, targetPrice: targetPrice, frequency: frequency, useYn: useYn, filter: filter)
    }
    
    func getAlarms(exchange: String) -> Observable<([Alarm], Int, Int)> {
        return repository.getAlarms()
            .map { alarms in
                let filteredAlarms = alarms.filter { $0.market == exchange }
                let totalAlarmsCount = filteredAlarms.count
                let activeAlarmsCount = filteredAlarms.filter { $0.isOn }.count
                return (filteredAlarms, totalAlarmsCount, activeAlarmsCount)
            }
    }
}
