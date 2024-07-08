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
        case alarmSelected(Int)
        case moveItem(Int, Int)
        case saveOrder
        case toggleAlarmSwitch(alarm: Alarm, isOn: Bool)
        case deleteAlarm(Int,Int)
        case updateSearchText(String)
        case clearButtonTapped
        case sortByCoin
        case sortBySetPrice
    }
    
    enum Mutation {
        case setLocalizedMarkets([Market])
        case setSelectedMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        case setAlarms([Alarm])
        case setUnit(String)
        case setOnCnt(Int)
        case setTotalCnt(Int)
        case updateAlarm(Alarm)
        case deleteAlarm(Int)
        case setSearchText(String)
        case setFilteredAlarms([Alarm])
        case setCoinSortOrder(SortOrder)
        case setSetPriceSortOrder(SortOrder)
    }
    
    struct State {
        var selectedMarket: Int = 0
        var markets: [Market]
        var alarms: [Alarm] = []
        var unit: String = "USDT"
        var onCnt: Int = 0
        var totalCnt: Int = 0
        var searchText: String = ""
        var filteredAlarms: [Alarm] = []
        var coinSortOrder: SortOrder = .none
        var setPriceSortOrder: SortOrder = .none
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
            return alarmUseCase.getAlarms(market: currentState.markets[index].localizationKey)
                .flatMap { [weak self] (alarmList, totalCnt, onCnt) -> Observable<Mutation> in
                    let market = self?.currentState.markets[index].localizationKey
                    let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
                    return .concat([
                        .just(.setSelectedMarket(index)),
                        .just(.setAlarms(alarmList)),
                        .just(.setOnCnt(onCnt)),
                        .just(.setTotalCnt(totalCnt)),
                        .just(.setFilteredAlarms(alarmList)),
                        .just(.setUnit(unit)),
                        .just(.setSearchText(""))
                    ])
                }
                .catch { [weak self] error in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .alarmSelected(let index):
            let alarm = currentState.filteredAlarms[index]
            self.steps.accept(AlarmStep.navigateToModifyAlarmViewController(market: currentState.markets[currentState.selectedMarket].localizationKey, alarm: alarm))
            return .empty()
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
            return alarmUseCase.updateAlarm(pushId: alarm.alarmId, market: alarm.market, symbol: alarm.coinTitle, targetPrice: alarm.setPrice, frequency: alarm.cycle, useYn: isOn ? "Y" : "N", filter: alarm.filter)
                .flatMap { [weak self] _ -> Observable<Mutation> in
                    if isOn {
                        return .concat([
                            .just(.updateAlarm(updatedAlarm)),
                            .just(.setOnCnt((self?.currentState.onCnt ?? 0)+1))
                        ])
                    }
                    else {
                        return .concat([
                            .just(.updateAlarm(updatedAlarm)),
                            .just(.setOnCnt((self?.currentState.onCnt ?? 0)-1))
                        ])
                    }
                }
                .catch { [weak self] _ in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .deleteAlarm(let id, let index):
            return alarmUseCase.deleteAlarm(pushId: id)
                .flatMap { [weak self] _ -> Observable<Mutation> in
                    return .concat([
                        .just(.deleteAlarm(index)),
                        .just(.setTotalCnt((self?.currentState.totalCnt ?? 0) - 1))
                    ])
                }
                .catch { [weak self] _ in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .updateSearchText(let searchText):
            let filteredAlarms: [Alarm]
            if searchText.isEmpty {
                var sortedAlarms = currentState.alarms
                if self.currentState.coinSortOrder != SortOrder.none {
                    sortedAlarms = self.sortAlarms(sortedAlarms, by: \.coinTitle, order: self.currentState.coinSortOrder)
                }
                if self.currentState.setPriceSortOrder != SortOrder.none {
                    sortedAlarms = self.sortAlarms(sortedAlarms, by: \.setPrice, order: self.currentState.setPriceSortOrder)
                }
                filteredAlarms = sortedAlarms
            }
            else {
                filteredAlarms = currentState.alarms.filter { $0.coinTitle.lowercased().contains(searchText.lowercased()) }
            }
            return .concat([
                .just(.setSearchText(searchText)),
                .just(.setFilteredAlarms(filteredAlarms))
            ])
        case .clearButtonTapped:
            return .concat([
                .just(.setSearchText("")),
                .just(.setFilteredAlarms(currentState.alarms))
            ])
        case .sortByCoin:
            let newOrder: SortOrder
            switch currentState.coinSortOrder {
            case .none, .descending:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            }
            let sortedAlarms = self.sortAlarms(currentState.filteredAlarms, by: \.coinTitle, order: newOrder)
            return .concat([
                .just(.setCoinSortOrder(newOrder)),
                .just(.setFilteredAlarms(sortedAlarms))
            ])
        case .sortBySetPrice:
            let newOrder: SortOrder
            switch currentState.setPriceSortOrder {
            case .none, .descending:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            }
            let sortedAlarms = self.sortAlarms(currentState.filteredAlarms, by: \.setPrice, order: newOrder)
            return .concat([
                .just(.setSetPriceSortOrder(newOrder)),
                .just(.setFilteredAlarms(sortedAlarms))
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
        case .setUnit(let unit):
            newState.unit = unit
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
            newState.filteredAlarms.remove(at: index)
        case .setSearchText(let searchText):
            newState.searchText = searchText
        case .setFilteredAlarms(let filteredAlarms):
            newState.filteredAlarms = filteredAlarms
        case .setCoinSortOrder(let order):
            newState.coinSortOrder = order
            newState.setPriceSortOrder = .none
        case .setSetPriceSortOrder(let order):
            newState.setPriceSortOrder = order
            newState.coinSortOrder = .none
        }
        return newState
    }
    
    private func sortAlarms(_ alarms: [Alarm], by keyPath: PartialKeyPath<Alarm>, order: SortOrder) -> [Alarm] {
        var sortedAlarms = alarms
        
        sortedAlarms.sort {
            let lhs: Any
            let rhs: Any
            
            if keyPath == \Alarm.setPrice, let lhsValue = $0[keyPath: keyPath] as? String, let rhsValue = $1[keyPath: keyPath] as? String {
                lhs = Double(lhsValue) ?? 0.0
                rhs = Double(rhsValue) ?? 0.0
            }
            else {
                lhs = $0[keyPath: keyPath]
                rhs = $1[keyPath: keyPath]
            }
            
            switch order {
            case .ascending:
                if let lhs = lhs as? Double, let rhs = rhs as? Double {
                    return lhs < rhs
                }
                if let lhs = lhs as? String, let rhs = rhs as? String {
                    return lhs < rhs
                }
                return false
            case .descending:
                if let lhs = lhs as? Double, let rhs = rhs as? Double {
                    return lhs > rhs
                }
                if let lhs = lhs as? String, let rhs = rhs as? String {
                    return lhs > rhs
                }
                return false
            case .none:
                return true
            }
        }
        
        return sortedAlarms
    }
}
