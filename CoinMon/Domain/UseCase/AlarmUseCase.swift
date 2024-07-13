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
    
    func fetchAlarmList(market: String) -> Observable<([Alarm], Int, Int)> {
        return repository.fetchAlarmList()
            .map { alarms in
                let filteredAlarms = alarms.filter { $0.market == market }
                    .sorted { Double($0.setPrice) ?? 0 > Double($1.setPrice) ?? 0 }
                let totalAlarmsCount = alarms.count
                let activeAlarmsCount = filteredAlarms.filter { $0.isOn }.count
                return (filteredAlarms, totalAlarmsCount, activeAlarmsCount)
            }
    }
}
