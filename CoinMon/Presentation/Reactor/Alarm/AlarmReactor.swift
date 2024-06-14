import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class AlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let alarmUseCase: AlarmUseCase
    
    init(alarmUseCase: AlarmUseCase) {
        self.alarmUseCase = alarmUseCase
        var markets = [
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "바이낸스"), localizationKey: "Binance"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "바이비트"), localizationKey: "Bybit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "업비트"), localizationKey: "Upbit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "빗썸"), localizationKey: "Bithumb")
        ]
        
        if let savedOrder = UserDefaults.standard.stringArray(forKey: "marketOrderAtAlarm") {
            markets.sort { market1, market2 in
                if let index1 = savedOrder.firstIndex(of: market1.localizationKey),
                   let index2 = savedOrder.firstIndex(of: market2.localizationKey) {
                    return index1 < index2
                }
                return false
            }
        }
        
        self.initialState = State(markets: markets)
    }
    
    enum Action {
        case addAlarmButtonTapped
        case updateLocalizedMarkets
        case selectMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        case toggleAlarmSwitch(alarm: Alarm, isOn: Bool)
        case deleteAlarm(Int,Int)
        case updateSearchText(String)
    }
    
    enum Mutation {
        case setLocalizedMarkets([Market])
        case setSelectedMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        case setAlarms([Alarm])
        case setOnCnt(Int)
        case setTotalCnt(Int)
        case updateAlarm(Alarm)
        case deleteAlarm(Int)
        case setSearchText(String)
        case setFilteredAlarms([Alarm])
    }
    
    struct State {
        var selectedMarket: Int = 0
        var markets: [Market]
        var alarms: [Alarm] = []
        var onCnt: Int = 0
        var totalCnt: Int = 0
        var searchText: String = ""
        var filteredAlarms: [Alarm] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addAlarmButtonTapped:
            if currentState.totalCnt == 20 {
                self.steps.accept(AlarmStep.presentToRestrictedAlarmErrorAlertController)
                return .empty()
            }
            else {
                self.steps.accept(AlarmStep.navigateToAddAlarmViewController)
                return .empty()
            }
        case .updateLocalizedMarkets:
            let localizedMarkets = currentState.markets.map { Market(marketTitle: LocalizationManager.shared.localizedString(forKey: $0.localizationKey), localizationKey: $0.localizationKey) }
            return .just(.setLocalizedMarkets(localizedMarkets))
        case .selectMarket(let index):
            return alarmUseCase.getAlarms(exchange: currentState.markets[index].localizationKey)
                .flatMap { (alarmList, totalCnt, onCnt) -> Observable<Mutation> in
                    return .concat([
                        .just(.setSelectedMarket(index)),
                        .just(.setAlarms(alarmList)),
                        .just(.setOnCnt(onCnt)),
                        .just(.setTotalCnt(totalCnt)),
                        .just(.setFilteredAlarms(alarmList))
                    ])
                }
                .catch { [weak self] error in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .moveItem(let fromIndex, let toIndex):
            if currentState.selectedMarket == fromIndex {
                return .concat([
                    .just(.moveItem(fromIndex, toIndex)),
                    .just(.setSelectedMarket(toIndex))
                ])
            }
            else{
                return .just(.moveItem(fromIndex, toIndex))
            }
        case .saveOrder:
            return .just(.saveOrder)
        case .toggleAlarmSwitch(let alarm, let isOn):
            let updatedAlarm = Alarm(alarmId: alarm.alarmId, market: alarm.market, coinTitle: alarm.coinTitle, setPrice: alarm.setPrice, filter: alarm.filter, cycle: alarm.cycle, isOn: isOn)
            return alarmUseCase.updateAlarm(pushId: alarm.alarmId, exchange: alarm.market, symbol: alarm.coinTitle, targetPrice: alarm.setPrice, frequency: alarm.cycle, useYn: isOn ? "Y" : "N", filter: alarm.filter)
                .flatMap { _ -> Observable<Mutation> in
                    return .just(.updateAlarm(updatedAlarm))
                }
                .catch { [weak self] _ in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .deleteAlarm(let id, let index):
            return alarmUseCase.deleteAlarm(pushId: id)
                .flatMap { _ -> Observable<Mutation> in
                    return .just(.deleteAlarm(index))
                }
                .catch { [weak self] _ in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .updateSearchText(let searchText):
            let filteredAlarms = searchText.isEmpty ? currentState.alarms : currentState.alarms.filter { $0.coinTitle.lowercased().contains(searchText.lowercased()) }
            return .concat([
                .just(.setSearchText(searchText)),
                .just(.setFilteredAlarms(filteredAlarms))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLocalizedMarkets(let localizedMarkets):
            newState.markets = localizedMarkets
        case .setSelectedMarket(let index):
            newState.selectedMarket = index
        case .moveItem(let fromIndex, let toIndex):
            var markets = newState.markets
            let market = markets.remove(at: fromIndex)
            markets.insert(market, at: toIndex)
            newState.markets = markets
        case .saveOrder:
            let order = newState.markets.map { $0.localizationKey }
            UserDefaults.standard.set(order, forKey: "marketOrderAtAlarm")
        case .setAlarms(let alarms):
            newState.alarms = alarms
        case .setOnCnt(let cnt):
            newState.onCnt = cnt
        case .setTotalCnt(let cnt):
            newState.totalCnt = cnt
        case .updateAlarm(let updatedAlarm):
            if let index = newState.alarms.firstIndex(where: { $0.alarmId == updatedAlarm.alarmId }) {
                newState.alarms[index] = updatedAlarm
            }
        case .deleteAlarm(let index):
            newState.alarms.remove(at: index)
        case .setSearchText(let searchText):
            newState.searchText = searchText
        case .setFilteredAlarms(let filteredAlarms):
            newState.filteredAlarms = filteredAlarms
        }
        return newState
    }
}
