import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class PriceReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private var timerDisposable: Disposable?
    private let coinUseCase: CoinUseCase
    
    init(coinUseCase: CoinUseCase) {
        self.coinUseCase = coinUseCase
        var markets = [
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "바이낸스"), localizationKey: "Binance"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "바이비트"), localizationKey: "Bybit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "업비트"), localizationKey: "Upbit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "빗썸"), localizationKey: "Bithumb")
        ]
        
        if let savedOrder = UserDefaults.standard.stringArray(forKey: "marketOrderAtPrice") {
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
        case startTimer
        case stopTimer
        case loadPriceList
        case updateLocalizedMarkets
        case selectMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        case updateSearchText(String)
        case clearButtonTapped
        case sortByCoin
        case sortByPrice
        case sortByChange
        case sortByGap
    }
    
    enum Mutation {
        case setLocalizedMarkets([Market])
        case setSelectedMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        case setPriceList([CoinPrice])
        case setUnit(String)
        case setSearchText(String)
        case setFilteredPriceList([CoinPrice])
        case setCoinSortOrder(SortOrder)
        case setPriceSortOrder(SortOrder)
        case setChangeSortOrder(SortOrder)
        case setGapSortOrder(SortOrder)
    }
    
    struct State {
        var selectedMarket: Int = 0
        var markets: [Market]
        var priceList: [CoinPrice] = []
        var searchText: String = ""
        var unit: String = "USDT"
        var filteredPriceList: [CoinPrice] = []
        var coinSortOrder: SortOrder = .none
        var priceSortOrder: SortOrder = .none
        var changeSortOrder: SortOrder = .none
        var gapSortOrder: SortOrder = .none
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startTimer:
            startTimer()
            return .empty()
        case .stopTimer:
            stopTimer()
            return .empty()
        case .loadPriceList:
            return coinUseCase.fetchCoinsPriceListAtHome(market: currentState.markets[currentState.selectedMarket].localizationKey)
                .flatMap { [weak self] priceList -> Observable<Mutation> in
                    var sortedPriceList = priceList
                    if self?.currentState.coinSortOrder != SortOrder.none {
                        sortedPriceList = self?.sortPriceList(sortedPriceList, by: \.coinTitle, order: self?.currentState.coinSortOrder ?? .none) ?? priceList
                    }
                    if self?.currentState.priceSortOrder != SortOrder.none {
                        sortedPriceList = self?.sortPriceList(sortedPriceList, by: \.price, order: self?.currentState.priceSortOrder ?? .none) ?? priceList
                    }
                    if self?.currentState.changeSortOrder != SortOrder.none {
                        sortedPriceList = self?.sortPriceList(sortedPriceList, by: \.change, order: self?.currentState.changeSortOrder ?? .none) ?? priceList
                    }
                    if self?.currentState.gapSortOrder != SortOrder.none {
                        sortedPriceList = self?.sortPriceList(sortedPriceList, by: \.gap, order: self?.currentState.gapSortOrder ?? .none) ?? priceList
                    }
                    sortedPriceList = self?.filterPriceList(priceList: sortedPriceList, searchText: self?.currentState.searchText ?? "") ?? priceList
                    return .concat([
                        .just(.setPriceList(priceList)),
                        .just(.setFilteredPriceList(sortedPriceList))
                    ])
                }
                .catch { [weak self] error in
                    self?.steps.accept(HomeStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .updateLocalizedMarkets:
            let localizedMarkets = currentState.markets.map { Market(marketTitle: LocalizationManager.shared.localizedString(forKey: $0.localizationKey), localizationKey: $0.localizationKey) }
            return .just(.setLocalizedMarkets(localizedMarkets))
        case .selectMarket(let index):
            return coinUseCase.fetchCoinsPriceListAtHome(market: currentState.markets[index].localizationKey)
                .flatMap { [weak self] priceList -> Observable<Mutation> in
                    let market = self?.currentState.markets[index].localizationKey
                    let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
                    var sortedPriceList = priceList
                    if self?.currentState.coinSortOrder != SortOrder.none {
                        sortedPriceList = self?.sortPriceList(sortedPriceList, by: \.coinTitle, order: self?.currentState.coinSortOrder ?? .none) ?? priceList
                    }
                    if self?.currentState.priceSortOrder != SortOrder.none {
                        sortedPriceList = self?.sortPriceList(sortedPriceList, by: \.price, order: self?.currentState.priceSortOrder ?? .none) ?? priceList
                    }
                    if self?.currentState.changeSortOrder != SortOrder.none {
                        sortedPriceList = self?.sortPriceList(sortedPriceList, by: \.change, order: self?.currentState.changeSortOrder ?? .none) ?? priceList
                    }
                    if self?.currentState.gapSortOrder != SortOrder.none {
                        sortedPriceList = self?.sortPriceList(sortedPriceList, by: \.gap, order: self?.currentState.gapSortOrder ?? .none) ?? priceList
                    }
                    return .concat([
                        .just(.setPriceList(priceList)),
                        .just(.setFilteredPriceList(sortedPriceList)),
                        .just(.setUnit(unit)),
                        .just(.setSelectedMarket(index)),
                        .just(.setSearchText(""))
                    ])
                }
                .catch { [weak self] error in
                    self?.steps.accept(HomeStep.presentToNetworkErrorAlertController)
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
        case .updateSearchText(let searchText):
            let filteredPriceList: [CoinPrice]
            if searchText.isEmpty {
                var sortedPriceList = currentState.priceList
                if currentState.coinSortOrder != .none {
                    sortedPriceList = sortPriceList(sortedPriceList, by: \.coinTitle, order: currentState.coinSortOrder)
                } 
                else if currentState.priceSortOrder != .none {
                    sortedPriceList = sortPriceList(sortedPriceList, by: \.price, order: currentState.priceSortOrder)
                } 
                else if currentState.changeSortOrder != .none {
                    sortedPriceList = sortPriceList(sortedPriceList, by: \.change, order: currentState.changeSortOrder)
                } 
                else if currentState.gapSortOrder != .none {
                    sortedPriceList = sortPriceList(sortedPriceList, by: \.gap, order: currentState.gapSortOrder)
                }
                filteredPriceList = sortedPriceList
            } else {
                filteredPriceList = currentState.priceList.filter { $0.coinTitle.lowercased().contains(searchText.lowercased()) }
            }
            return .concat([
                .just(.setSearchText(searchText)),
                .just(.setFilteredPriceList(filteredPriceList))
            ])
        case .clearButtonTapped:
            return .concat([
                .just(.setSearchText("")),
                .just(.setFilteredPriceList(currentState.priceList))
            ])
        case .sortByCoin:
            let newOrder: SortOrder
            switch currentState.coinSortOrder {
            case .none, .descending:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            }
            let sortedPriceList = self.sortPriceList(currentState.filteredPriceList, by: \.coinTitle, order: newOrder)
            return .concat([
                .just(.setCoinSortOrder(newOrder)),
                .just(.setFilteredPriceList(sortedPriceList))
            ])
        case .sortByPrice:
            let newOrder: SortOrder
            switch currentState.priceSortOrder {
            case .none, .descending:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            }
            let sortedPriceList = self.sortPriceList(currentState.filteredPriceList, by: \.price, order: newOrder)
            return .concat([
                .just(.setPriceSortOrder(newOrder)),
                .just(.setFilteredPriceList(sortedPriceList))
            ])
        case .sortByChange:
            let newOrder: SortOrder
            switch currentState.changeSortOrder {
            case .none, .descending:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            }
            let sortedPriceList = self.sortPriceList(currentState.filteredPriceList, by: \.change, order: newOrder)
            return .concat([
                .just(.setChangeSortOrder(newOrder)),
                .just(.setFilteredPriceList(sortedPriceList))
            ])
        case .sortByGap:
            let newOrder: SortOrder
            switch currentState.gapSortOrder {
            case .none, .descending:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            }
            let sortedPriceList = self.sortPriceList(currentState.filteredPriceList, by: \.gap, order: newOrder)
            return .concat([
                .just(.setGapSortOrder(newOrder)),
                .just(.setFilteredPriceList(sortedPriceList))
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
            UserDefaults.standard.set(order, forKey: "marketOrderAtPrice")
        case .setPriceList(let priceList):
            newState.priceList = priceList
        case .setUnit(let unit):
            newState.unit = unit
        case .setSearchText(let searchText):
            newState.searchText = searchText
        case .setFilteredPriceList(let filteredPriceList):
            newState.filteredPriceList = filteredPriceList
        case .setCoinSortOrder(let order):
            newState.coinSortOrder = order
            newState.priceSortOrder = .none
            newState.changeSortOrder = .none
            newState.gapSortOrder = .none
        case .setPriceSortOrder(let order):
            newState.priceSortOrder = order
            newState.coinSortOrder = .none
            newState.changeSortOrder = .none
            newState.gapSortOrder = .none
        case .setChangeSortOrder(let order):
            newState.coinSortOrder = .none
            newState.priceSortOrder = .none
            newState.changeSortOrder = order
            newState.gapSortOrder = .none
        case .setGapSortOrder(let order):
            newState.coinSortOrder = .none
            newState.priceSortOrder = .none
            newState.changeSortOrder = .none
            newState.gapSortOrder = order
        }
        return newState
    }
    
    private func startTimer() {
        stopTimer()
        timerDisposable = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.action.onNext(.loadPriceList)
            })
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
    
    private func sortPriceList(_ priceList: [CoinPrice], by keyPath: PartialKeyPath<CoinPrice>, order: SortOrder) -> [CoinPrice] {
        var sortedPriceList = priceList
        
        sortedPriceList.sort {
            let lhs: Any
            let rhs: Any
            
            if keyPath == \CoinPrice.price, let lhsValue = $0[keyPath: keyPath] as? String, let rhsValue = $1[keyPath: keyPath] as? String {
                lhs = Double(lhsValue) ?? 0.0
                rhs = Double(rhsValue) ?? 0.0
            }
            else if keyPath == \CoinPrice.change, let lhsValue = $0[keyPath: keyPath] as? String, let rhsValue = $1[keyPath: keyPath] as? String {
                lhs = Double(lhsValue) ?? 0.0
                rhs = Double(rhsValue) ?? 0.0
            }
            else if keyPath == \CoinPrice.gap, let lhsValue = $0[keyPath: keyPath] as? String, let rhsValue = $1[keyPath: keyPath] as? String {
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
        
        return sortedPriceList
    }
    
    private func filterPriceList(priceList: [CoinPrice], searchText: String) -> [CoinPrice] {
        guard !searchText.isEmpty else { return priceList }
        return priceList.filter { $0.coinTitle.lowercased().contains(searchText.lowercased()) }
    }
}
