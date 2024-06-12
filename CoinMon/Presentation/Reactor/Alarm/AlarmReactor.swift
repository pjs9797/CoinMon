import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class AlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    
    init() {
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
        case deleteAlarm(Int)
    }
    
    enum Mutation {
        case setLocalizedMarkets([Market])
        case setSelectedMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        case deleteAlarm(Int)
    }
    
    struct State {
        var selectedMarket: Int = 0
        var markets: [Market]
        var alarms: [AlarmList] = [
            AlarmList(coinTitle: "BTC", setPrice: 111111, currentPrice: 222222, isOn: true),
            AlarmList(coinTitle: "BTC", setPrice: 111111, currentPrice: 222222, isOn: false),
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .addAlarmButtonTapped:
            self.steps.accept(AlarmStep.navigateToAddAlarmViewController)
            return .empty()
        case .updateLocalizedMarkets:
            let localizedMarkets = currentState.markets.map { Market(marketTitle: LocalizationManager.shared.localizedString(forKey: $0.localizationKey), localizationKey: $0.localizationKey) }
            return .just(.setLocalizedMarkets(localizedMarkets))
        case .selectMarket(let index):
            return .just(.setSelectedMarket(index))
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
        case .deleteAlarm(let index):
            return .just(.deleteAlarm(index))
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
        case .deleteAlarm(let index):
            newState.alarms.remove(at: index)
        }
        return newState
    }
}
