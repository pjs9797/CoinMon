import RxSwift

class AlarmUseCase {
    private let repository: AlarmRepositoryInterface

    init(repository: AlarmRepositoryInterface) {
        self.repository = repository
    }
    
    func createAlarm(market: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<String> {
        let marketUpper = market.uppercased()
        return repository.createAlarm(exchange: marketUpper, symbol: symbol, targetPrice: targetPrice, frequency: frequency, useYn: useYn, filter: filter)
    }
    
    func deleteAlarm(pushId: Int) -> Observable<String> {
        return repository.deleteAlarm(pushId: pushId)
    }
    
    func updateAlarm(pushId: Int, market: String, symbol: String, targetPrice: String, frequency: String, useYn: String, filter: String) -> Observable<String> {
        let marketUpper = market.uppercased()
        return repository.updateAlarm(pushId: pushId, exchange: marketUpper, symbol: symbol, targetPrice: targetPrice, frequency: frequency, useYn: useYn, filter: filter)
    }
    
    func getAlarms(market: String) -> Observable<([Alarm], Int, Int)> {
        return repository.getAlarms()
            .map { alarms in
                let filteredAlarms = alarms.filter { $0.market == market }
                let totalAlarmsCount = alarms.count
                let activeAlarmsCount = filteredAlarms.filter { $0.isOn }.count
                return (filteredAlarms, totalAlarmsCount, activeAlarmsCount)
            }
    }
}
