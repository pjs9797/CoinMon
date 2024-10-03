import ReactorKit
import RxCocoa
import RxFlow

class SelectCoinAtDetailReactor: ReactorKit.Reactor,Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let coinUseCase: CoinUseCase
    
    init(coinUseCase: CoinUseCase){
        self.coinUseCase = coinUseCase
    }
    
    enum Action {
        case loadCoinData
        case backButtonTapped
        case selectMarket(Int)
        case selectCoin(Int)
        case updateSearchText(String)
        case clearButtonTapped
        case sortByCoin
        case sortByPrice
    }
    
    enum Mutation {
        case setSelectedMarket(Int)
        case setMarket(String)
        case setCoinData([CoinPrice])
        case setUnit(String)
        case setSearchText(String)
        case setFilteredCoins([CoinPrice])
        case setCoinSortOrder(SortOrder)
        case setSetPriceSortOrder(SortOrder)
    }
    
    struct State {
        var selectedMarket: Int = 0
        var markets: [Market] = [
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Binance"), localizationKey: "Binance"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bybit"), localizationKey: "Bybit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Upbit"), localizationKey: "Upbit"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bithumb"), localizationKey: "Bithumb")
        ]
        var coins: [CoinPrice] = []
        var market: String = "Binance"
        var unit: String = "USDT"
        var searchText: String = ""
        var filteredCoins: [CoinPrice] = []
        var coinSortOrder: SortOrder = .none
        var setPriceSortOrder: SortOrder = .none
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadCoinData:
            return self.coinUseCase.fetchCoinPriceForSelectCoinsAtAlarm(market: "Binance")
                .flatMap { coinData -> Observable<Mutation> in
                    let market = "Binance"
                    let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
                    return .concat([
                        .just(.setCoinData(coinData)),
                        .just(.setFilteredCoins(coinData)),
                        .just(.setUnit(unit)),
                        .just(.setMarket(market))
                    ])
                }
                .catch { [weak self] error in
                    self?.steps.accept(HomeStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .backButtonTapped:
            self.steps.accept(HomeStep.popViewController)
            return .empty()
        case .selectMarket(let index):
            return self.coinUseCase.fetchCoinPriceForSelectCoinsAtAlarm(market: currentState.markets[index].localizationKey)
                .flatMap { [weak self] coinData -> Observable<Mutation> in
                    let market = self?.currentState.markets[index].localizationKey
                    let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
                    return .concat([
                        .just(.setCoinData(coinData)),
                        .just(.setFilteredCoins(coinData)),
                        .just(.setUnit(unit)),
                        .just(.setSelectedMarket(index)),
                        .just(.setMarket(market ?? "Binance"))
                    ])
                }
                .catch { [weak self] error in
                    self?.steps.accept(HomeStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .selectCoin(let index):
            let coin = currentState.filteredCoins[index].coinTitle
            self.steps.accept(HomeStep.navigateToDetailCoinInfoViewController(market: currentState.market, coin: coin))
            return .empty()
        case .updateSearchText(let searchText):
            let filteredCoins: [CoinPrice]
            if searchText.isEmpty {
                var sortedCoins = currentState.coins
                if self.currentState.coinSortOrder != SortOrder.none {
                    sortedCoins = self.sortCoins(sortedCoins, by: \.coinTitle, order: self.currentState.coinSortOrder)
                }
                if self.currentState.setPriceSortOrder != SortOrder.none {
                    sortedCoins = self.sortCoins(sortedCoins, by: \.price, order: self.currentState.setPriceSortOrder)
                }
                filteredCoins = sortedCoins
            }
            else {
                filteredCoins = currentState.coins.filter { $0.coinTitle.lowercased().contains(searchText.lowercased()) }
            }
            return .concat([
                .just(.setSearchText(searchText)),
                .just(.setFilteredCoins(filteredCoins))
            ])
        case .clearButtonTapped:
            return .concat([
                .just(.setSearchText("")),
                .just(.setFilteredCoins(currentState.coins))
            ])
        case .sortByCoin:
            let newOrder: SortOrder
            switch currentState.coinSortOrder {
            case .none:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            case .descending:
                newOrder = .none
            }
            let sortedCoins = self.sortCoins(currentState.filteredCoins, by: \.coinTitle, order: newOrder)
            return .concat([
                .just(.setCoinSortOrder(newOrder)),
                .just(.setFilteredCoins(sortedCoins))
            ])
        case .sortByPrice:
            let newOrder: SortOrder
            switch currentState.setPriceSortOrder {
            case .none:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            case .descending:
                newOrder = .none
            }
            let sortedCoins = self.sortCoins(currentState.filteredCoins, by: \.price, order: newOrder)
            return .concat([
                .just(.setSetPriceSortOrder(newOrder)),
                .just(.setFilteredCoins(sortedCoins))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedMarket(let index):
            newState.selectedMarket = index
        case .setMarket(let market):
            newState.market = market
        case .setCoinData(let coinData):
            newState.coins = coinData
        case .setUnit(let unit):
            newState.unit = unit
        case .setSearchText(let searchText):
            newState.searchText = searchText
        case .setFilteredCoins(let filteredCoins):
            newState.filteredCoins = filteredCoins
        case .setCoinSortOrder(let order):
            newState.coinSortOrder = order
            newState.setPriceSortOrder = .none
        case .setSetPriceSortOrder(let order):
            newState.coinSortOrder = .none
            newState.setPriceSortOrder = order
        }
        return newState
    }
    
    private func sortCoins(_ coins: [CoinPrice], by keyPath: PartialKeyPath<CoinPrice>, order: SortOrder) -> [CoinPrice] {
        var sortedCoins = coins
        
        sortedCoins.sort {
            let lhs: Any
            let rhs: Any
            
            let actualKeyPath = order == .none ? \CoinPrice.price : keyPath
            
            if actualKeyPath == \CoinPrice.price, let lhsValue = $0[keyPath: actualKeyPath] as? String, let rhsValue = $1[keyPath: actualKeyPath] as? String {
                lhs = Double(lhsValue) ?? 0.0
                rhs = Double(rhsValue) ?? 0.0
            }
            else {
                lhs = $0[keyPath: actualKeyPath]
                rhs = $1[keyPath: actualKeyPath]
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
                if let lhs = lhs as? Double, let rhs = rhs as? Double {
                    return lhs > rhs
                }
                return false
            }
        }
        return sortedCoins
    }
}
