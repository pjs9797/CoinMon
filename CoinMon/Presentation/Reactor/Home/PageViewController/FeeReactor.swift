import UIKit.UIImage
import ReactorKit
import RxCocoa

class FeeReactor: ReactorKit.Reactor {
    let initialState: State
    
    init() {
        var markets = [
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "업비트"), localizationKey: "Upbit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "빗썸"), localizationKey: "Bithumb")
        ]
        
        if let savedOrder = UserDefaults.standard.stringArray(forKey: "marketOrderAtFee") {
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
        case updateLocalizedMarkets
        case selectItem(Int)
        case moveItem(Int, Int)
        case saveOrder
    }
    
    enum Mutation {
        case setLocalizedMarkets([Market])
        case setSelectedItem(Int)
        case moveItem(Int, Int)
        case saveOrder
    }
    
    struct State {
        var selectedItem: Int = 0
        var markets: [Market]
        var feeList: [FeeList] = [
            FeeList(coinTitle: "BTC", fee: "0.01"),
            FeeList(coinTitle: "ETH", fee: "0.03"),
            FeeList(coinTitle: "XRP", fee: "0.05"),
            FeeList(coinTitle: "SOL", fee: "0.005"),
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateLocalizedMarkets:
            let localizedMarkets = currentState.markets.map { Market(marketTitle: LocalizationManager.shared.localizedString(forKey: $0.localizationKey), localizationKey: $0.localizationKey) }
            return .just(.setLocalizedMarkets(localizedMarkets))
        case .selectItem(let index):
            return .just(.setSelectedItem(index))
        case .moveItem(let fromIndex, let toIndex):
            if currentState.selectedItem == fromIndex {
                return .concat([
                    .just(.moveItem(fromIndex, toIndex)),
                    .just(.setSelectedItem(toIndex))
                ])
            }
            else{
                return .just(.moveItem(fromIndex, toIndex))
            }
        case .saveOrder:
            return .just(.saveOrder)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLocalizedMarkets(let localizedMarkets):
            newState.markets = localizedMarkets
        case .setSelectedItem(let index):
            newState.selectedItem = index
        case .moveItem(let fromIndex, let toIndex):
            var markets = newState.markets
            let market = markets.remove(at: fromIndex)
            markets.insert(market, at: toIndex)
            newState.markets = markets
        case .saveOrder:
            let order = newState.markets.map { $0.localizationKey }
            UserDefaults.standard.set(order, forKey: "marketOrderAtFee")
        }
        return newState
    }
}
