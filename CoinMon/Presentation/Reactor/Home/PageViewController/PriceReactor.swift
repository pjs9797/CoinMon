import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class PriceReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private var timerDisposable: Disposable?
    private let coinUseCase: CoinUseCase
    private let favoritesUseCase: FavoritesUseCase
    
    init(coinUseCase: CoinUseCase, favoritesUseCase: FavoritesUseCase) {
        self.coinUseCase = coinUseCase
        self.favoritesUseCase = favoritesUseCase
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
        // 타이머
        case startTimer
        case stopTimer
        
        // 검색
        case updateSearchText(String)
        case clearButtonTapped
        
        // 버튼 탭
        case marketButtonTapped
        case favoriteButtonTapped
        case editButtonTapped
        
        // 거래소
        case updateLocalizedMarkets
        case selectMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        
        // 코인
        case loadPriceList
        //case loadFavoritesList
        case sortByCoin
        case sortByPrice
        case sortByChange
        case sortByGap
        case selectCoin(Int)
    }
    
    enum Mutation {
        // 버튼 상태
        case setMarketButton(Bool)
        case setFavoriteButton(Bool)
        
        // 검색
        case setSearchText(String)
        
        // 거래소
        case setLocalizedMarkets([Market])
        case setSelectedMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        
        // 코인
        case setPriceList([CoinPriceChangeGap])
        case setUnit(String)
        case setFilteredPriceList([CoinPriceChangeGap])
        case setInitialFavoritesOrder([CoinPriceChangeGap])
        case setCoinSortOrder(SortOrder)
        case setPriceSortOrder(SortOrder)
        case setChangeSortOrder(SortOrder)
        case setGapSortOrder(SortOrder)
    }
    
    struct State {
        // 버튼 상태
        var isTappedMarketButton: Bool = true
        var isTappedFavoriteButton: Bool = false
        
        // 검색
        var searchText: String = ""
        
        // 거래소
        var selectedMarket: Int = 0
        var markets: [Market]
        
        // 코인
        var unit: String = "USDT"
        var priceList: [CoinPriceChangeGap] = []
        var filteredPriceList: [CoinPriceChangeGap] = []
        var initialFavoritesList: [CoinPriceChangeGap] = []
        var coinSortOrder: SortOrder = .none
        var priceSortOrder: SortOrder = .none
        var changeSortOrder: SortOrder = .none
        var gapSortOrder: SortOrder = .none
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 타이머
        case .startTimer:
            startTimer()
            return .empty()
        case .stopTimer:
            stopTimer()
            return .empty()
            
            // 검색
        case .updateSearchText(let searchText):
            let filteredPriceList: [CoinPriceChangeGap]
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
            
            // 버튼 탭
        case .marketButtonTapped:
            return .concat([
                .just(.setMarketButton(true)),
                .just(.setFavoriteButton(false))
            ])
        case .favoriteButtonTapped:
            return .concat([
                .just(.setMarketButton(false)),
                .just(.setFavoriteButton(true))
            ])
        case .editButtonTapped:
            self.steps.accept(HomeStep.navigateToEditFavoritesViewController)
            return .empty()
            
            // 거래소
        case .updateLocalizedMarkets:
            let localizedMarkets = currentState.markets.map { Market(marketTitle: LocalizationManager.shared.localizedString(forKey: $0.localizationKey), localizationKey: $0.localizationKey) }
            return .just(.setLocalizedMarkets(localizedMarkets))
        case .selectMarket(let index):
            if currentState.isTappedFavoriteButton == true {
                return self.favoritesUseCase.fetchCoinPriceChangeGapListByFavorites(market: currentState.markets[index].localizationKey)
                    .flatMap { [weak self] priceList -> Observable<Mutation> in
                        let sortedAndFilteredList = self?.sortAndFilterPriceList(priceList) ?? []
                        return .concat([
                            .just(.setPriceList(priceList)),
                            .just(.setFilteredPriceList(sortedAndFilteredList)),
                            .just(.setSelectedMarket(index))
                        ])
                    }
                    .catch { [weak self] error in
                        ErrorHandler.handle(error) { (step: HomeStep) in
                            self?.steps.accept(step)
                        }
                        return .empty()
                    }
            }
            else {
                return self.coinUseCase.fetchCoinPriceChangeGapList(market: currentState.markets[index].localizationKey)
                    .flatMap { [weak self] priceList -> Observable<Mutation> in
                        let sortedAndFilteredList = self?.sortAndFilterPriceList(priceList) ?? []
                        return .concat([
                            .just(.setPriceList(priceList)),
                            .just(.setFilteredPriceList(sortedAndFilteredList)),
                            .just(.setSelectedMarket(index))
                        ])
                    }
                    .catch { [weak self] error in
                        ErrorHandler.handle(error) { (step: HomeStep) in
                            self?.steps.accept(step)
                        }
                        return .empty()
                    }
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
            
            // 코인
        case .loadPriceList:
            print(123123123123)
            if currentState.isTappedFavoriteButton == true {
                return self.favoritesUseCase.fetchCoinPriceChangeGapListByFavorites(market: currentState.markets[currentState.selectedMarket].localizationKey)
                    .flatMap { [weak self] priceList -> Observable<Mutation> in
                        let sortedAndFilteredList = self?.sortAndFilterPriceList(priceList) ?? []
                        return .concat([
                            .just(.setPriceList(priceList)),
                            .just(.setFilteredPriceList(sortedAndFilteredList))
                        ])
                    }
                    .catch { [weak self] error in
                        ErrorHandler.handle(error) { (step: HomeStep) in
                            self?.steps.accept(step)
                        }
                        return .empty()
                    }
            }
            else {
                return self.coinUseCase.fetchCoinPriceChangeGapList(market: currentState.markets[currentState.selectedMarket].localizationKey)
                    .flatMap { [weak self] priceList -> Observable<Mutation> in
                        let sortedAndFilteredList = self?.sortAndFilterPriceList(priceList) ?? []
                        
                        return .concat([
                            .just(.setPriceList(priceList)),
                            .just(.setFilteredPriceList(sortedAndFilteredList))
                        ])
                    }
                    .catch { [weak self] error in
                        ErrorHandler.handle(error) { (step: HomeStep) in
                            self?.steps.accept(step)
                        }
                        return .empty()
                    }
            }
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
            if newOrder == .none && currentState.isTappedFavoriteButton {
                return .concat([
                    .just(.setGapSortOrder(newOrder)),
                    .just(.setFilteredPriceList(currentState.initialFavoritesList))
                ])
            }
            else{
                let sortedPriceList = self.sortPriceList(currentState.filteredPriceList, by: \.coinTitle, order: newOrder)
                return .concat([
                    .just(.setCoinSortOrder(newOrder)),
                    .just(.setFilteredPriceList(sortedPriceList))
                ])
            }
        case .sortByPrice:
            let newOrder: SortOrder
            switch currentState.priceSortOrder {
            case .none:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            case .descending:
                newOrder = .none
            }
            if newOrder == .none && currentState.isTappedFavoriteButton {
                return .concat([
                    .just(.setGapSortOrder(newOrder)),
                    .just(.setFilteredPriceList(currentState.initialFavoritesList))
                ])
            }
            else{
                let sortedPriceList = self.sortPriceList(currentState.filteredPriceList, by: \.price, order: newOrder)
                return .concat([
                    .just(.setPriceSortOrder(newOrder)),
                    .just(.setFilteredPriceList(sortedPriceList))
                ])
            }
        case .sortByChange:
            let newOrder: SortOrder
            switch currentState.changeSortOrder {
            case .none:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            case .descending:
                newOrder = .none
            }
            if newOrder == .none && currentState.isTappedFavoriteButton {
                return .concat([
                    .just(.setGapSortOrder(newOrder)),
                    .just(.setFilteredPriceList(currentState.initialFavoritesList))
                ])
            }
            else{
                let sortedPriceList = self.sortPriceList(currentState.filteredPriceList, by: \.change, order: newOrder)
                return .concat([
                    .just(.setChangeSortOrder(newOrder)),
                    .just(.setFilteredPriceList(sortedPriceList))
                ])
            }
        case .sortByGap:
            let newOrder: SortOrder
            switch currentState.gapSortOrder {
            case .none:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            case .descending:
                newOrder = .none
            }
            if newOrder == .none && currentState.isTappedFavoriteButton {
                return .concat([
                    .just(.setGapSortOrder(newOrder)),
                    .just(.setFilteredPriceList(currentState.initialFavoritesList))
                ])
            }
            else{
                let sortedPriceList = self.sortPriceList(currentState.filteredPriceList, by: \.gap, order: newOrder)
                return .concat([
                    .just(.setGapSortOrder(newOrder)),
                    .just(.setFilteredPriceList(sortedPriceList))
                ])
            }
        case .selectCoin(let index):
            let market = currentState.markets[currentState.selectedMarket].localizationKey
            self.steps.accept(HomeStep.navigateToDetailCoinInfoViewController(market: market, coin: currentState.filteredPriceList[index].coinTitle))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMarketButton(let isTapped):
            newState.isTappedMarketButton = isTapped
        case .setFavoriteButton(let isTapped):
            newState.isTappedFavoriteButton = isTapped
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
        case .setInitialFavoritesOrder(let initialFavoritesList):
            newState.initialFavoritesList = initialFavoritesList
        case .setCoinSortOrder(let order):
            newState.coinSortOrder = order
            newState.priceSortOrder = .none
            newState.changeSortOrder = .none
            newState.gapSortOrder = .none
        case .setPriceSortOrder(let order):
            newState.coinSortOrder = .none
            newState.priceSortOrder = order
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
        timerDisposable = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.action.onNext(.loadPriceList)
            })
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
    
    private func updateFavoritesList(priceList: [CoinPriceChangeGap], index: Int) -> Observable<Mutation> {
        return self.favoritesUseCase.fetchFavorites(market: currentState.markets[index].localizationKey)
            .map { favorites -> [CoinPriceChangeGap] in
                let sortedFavorites = favorites.sorted { $0.favoritesOrder < $1.favoritesOrder }
                let favoriteCoinTitles = Set(sortedFavorites.map { $0.symbol })
                let favoriteItems = priceList.filter { favoriteCoinTitles.contains($0.coinTitle) }
                // 정렬 적용
                let sortedItems: [CoinPriceChangeGap]
                if self.currentState.coinSortOrder != .none {
                    sortedItems = self.sortPriceList(favoriteItems, by: \.coinTitle, order: self.currentState.coinSortOrder)
                } else if self.currentState.priceSortOrder != .none {
                    sortedItems = self.sortPriceList(favoriteItems, by: \.price, order: self.currentState.priceSortOrder)
                } else if self.currentState.changeSortOrder != .none {
                    sortedItems = self.sortPriceList(favoriteItems, by: \.change, order: self.currentState.changeSortOrder)
                } else if self.currentState.gapSortOrder != .none {
                    sortedItems = self.sortPriceList(favoriteItems, by: \.gap, order: self.currentState.gapSortOrder)
                } else {
                    // 모든 정렬이 .none일 경우 초기 정렬 상태 적용
                    sortedItems = favoriteItems.sorted { lhs, rhs in
                        guard let lhsIndex = sortedFavorites.firstIndex(where: { $0.symbol == lhs.coinTitle }),
                              let rhsIndex = sortedFavorites.firstIndex(where: { $0.symbol == rhs.coinTitle }) else {
                            return false
                        }
                        return lhsIndex < rhsIndex
                    }
                }
                
                return sortedItems
            }
            .flatMap { sortedItems -> Observable<Mutation> in
                return .concat([
                    .just(.setInitialFavoritesOrder(sortedItems)),
                    .just(.setFilteredPriceList(sortedItems))
                ])
            }
    }
    
    
    private func updateFullPriceList(priceList: [CoinPriceChangeGap]) -> Observable<Mutation> {
        var sortedPriceList = priceList
        if self.currentState.coinSortOrder != SortOrder.none {
            sortedPriceList = self.sortPriceList(sortedPriceList, by: \.coinTitle, order: self.currentState.coinSortOrder ) 
        }
        if self.currentState.priceSortOrder != SortOrder.none {
            sortedPriceList = self.sortPriceList(sortedPriceList, by: \.price, order: self.currentState.priceSortOrder ) 
        }
        if self.currentState.changeSortOrder != SortOrder.none {
            sortedPriceList = self.sortPriceList(sortedPriceList, by: \.change, order: self.currentState.changeSortOrder ) 
        }
        if self.currentState.gapSortOrder != SortOrder.none {
            sortedPriceList = self.sortPriceList(sortedPriceList, by: \.gap, order: self.currentState.gapSortOrder ) 
        }
        sortedPriceList = self.filterPriceList(priceList: sortedPriceList, searchText: self.currentState.searchText )
        return .concat([
            .just(.setPriceList(priceList)),
            .just(.setFilteredPriceList(sortedPriceList))
        ])
    }
    
    private func sortAndFilterPriceList(_ priceList: [CoinPriceChangeGap]) -> [CoinPriceChangeGap] {
            var sortedPriceList = priceList
            if self.currentState.coinSortOrder != SortOrder.none {
                sortedPriceList = self.sortPriceList(sortedPriceList, by: \.coinTitle, order: self.currentState.coinSortOrder)
            }
            if self.currentState.priceSortOrder != SortOrder.none {
                sortedPriceList = self.sortPriceList(sortedPriceList, by: \.price, order: self.currentState.priceSortOrder)
            }
            if self.currentState.changeSortOrder != SortOrder.none {
                sortedPriceList = self.sortPriceList(sortedPriceList, by: \.change, order: self.currentState.changeSortOrder)
            }
            if self.currentState.gapSortOrder != SortOrder.none {
                sortedPriceList = self.sortPriceList(sortedPriceList, by: \.gap, order: self.currentState.gapSortOrder)
            }
            return self.filterPriceList(priceList: sortedPriceList, searchText: self.currentState.searchText)
        }
    
    private func sortPriceList(_ priceList: [CoinPriceChangeGap], by keyPath: PartialKeyPath<CoinPriceChangeGap>, order: SortOrder) -> [CoinPriceChangeGap] {
        var sortedPriceList = priceList
        
        sortedPriceList.sort {
            let lhs: Any
            let rhs: Any
            
            let actualKeyPath = order == .none ? \CoinPriceChangeGap.price : keyPath
            
            if actualKeyPath == \CoinPriceChangeGap.price, let lhsValue = $0[keyPath: actualKeyPath] as? String, let rhsValue = $1[keyPath: actualKeyPath] as? String {
                lhs = Double(lhsValue) ?? 0.0
                rhs = Double(rhsValue) ?? 0.0
            }
            else if keyPath == \CoinPriceChangeGap.change, let lhsValue = $0[keyPath: actualKeyPath] as? String, let rhsValue = $1[keyPath: actualKeyPath] as? String {
                lhs = Double(lhsValue) ?? 0.0
                rhs = Double(rhsValue) ?? 0.0
            }
            else if keyPath == \CoinPriceChangeGap.gap, let lhsValue = $0[keyPath: actualKeyPath] as? String, let rhsValue = $1[keyPath: actualKeyPath] as? String {
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
                if currentState.isTappedFavoriteButton {
                    return false
                }
                else {
                    if let lhs = lhs as? Double, let rhs = rhs as? Double {
                        return lhs > rhs
                    }
                    return false
                }
            }
        }
        
        return sortedPriceList
    }
    
    private func filterPriceList(priceList: [CoinPriceChangeGap], searchText: String) -> [CoinPriceChangeGap] {
        guard !searchText.isEmpty else { return priceList }
        return priceList.filter { $0.coinTitle.lowercased().contains(searchText.lowercased()) }
    }
}
