import ReactorKit
import UIKit
import Foundation
import RxCocoa
import RxFlow

class FeeReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private var timerDisposable: Disposable?
    private let coinUseCase: CoinUseCase
    
    init(coinUseCase: CoinUseCase) {
        self.coinUseCase = coinUseCase
        var markets = [
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Binance"), localizationKey: "Binance"),
            Market(marketTitle: LocalizationManager.shared.localizedString(forKey: "Bybit"), localizationKey: "Bybit")
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
        case startTimer
        case stopTimer
        case loadFeeList
        case updateLocalizedMarkets
        case selectMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        case updateSearchText(String)
        case clearButtonTapped
        case sortByCoin
        case sortByFee
    }
    
    enum Mutation {
        case setFeeList([CoinFee])
        case setLocalizedMarkets([Market])
        case setSelectedMarket(Int)
        case moveItem(Int, Int)
        case saveOrder
        case setSearchText(String)
        case setFilteredFeeList([CoinFee])
        case setCoinSortOrder(SortOrder)
        case setFeeSortOrder(SortOrder)
    }
    
    struct State {
        var selectedMarket: Int = 0
        var markets: [Market]
        var feeList: [CoinFee] = []
        var searchText: String = ""
        var filteredFeeList: [CoinFee] = []
        var coinSortOrder: SortOrder = .none
        var feeSortOrder: SortOrder = .none
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startTimer:
            startTimer()
            return .empty()
        case .stopTimer:
            stopTimer()
            return .empty()
        case .loadFeeList:
            return coinUseCase.fetchCoinFeeList(market: currentState.markets[currentState.selectedMarket].localizationKey)
                .flatMap { [weak self] feeList -> Observable<Mutation> in
                    var sortedFeeList = feeList
                    if self?.currentState.coinSortOrder != SortOrder.none {
                        sortedFeeList = self?.sortFeeList(sortedFeeList, by: \.coinTitle, order: self?.currentState.coinSortOrder ?? .none) ?? feeList
                    }
                    if self?.currentState.feeSortOrder != SortOrder.none {
                        sortedFeeList = self?.sortFeeList(sortedFeeList, by: \.fee, order: self?.currentState.feeSortOrder ?? .none) ?? feeList
                    }
                    sortedFeeList = self?.filterFeeList(priceList: sortedFeeList, searchText: self?.currentState.searchText ?? "") ?? feeList
                    return .concat([
                        .just(.setFeeList(feeList)),
                        .just(.setFilteredFeeList(sortedFeeList))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: HomeStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .updateLocalizedMarkets:
            let localizedMarkets = currentState.markets.map { Market(marketTitle: LocalizationManager.shared.localizedString(forKey: $0.localizationKey), localizationKey: $0.localizationKey) }
            return .just(.setLocalizedMarkets(localizedMarkets))
        case .selectMarket(let index):
            return coinUseCase.fetchCoinFeeList(market: currentState.markets[currentState.selectedMarket].localizationKey)
                .flatMap { [weak self] feeList -> Observable<Mutation> in
                    var sortedFeeList = feeList
                    if self?.currentState.coinSortOrder != SortOrder.none {
                        sortedFeeList = self?.sortFeeList(sortedFeeList, by: \.coinTitle, order: self?.currentState.coinSortOrder ?? .none) ?? feeList
                    }
                    if self?.currentState.feeSortOrder != SortOrder.none {
                        sortedFeeList = self?.sortFeeList(sortedFeeList, by: \.fee, order: self?.currentState.feeSortOrder ?? .none) ?? feeList
                    }
                    sortedFeeList = self?.filterFeeList(priceList: sortedFeeList, searchText: self?.currentState.searchText ?? "") ?? feeList
                    return .concat([
                        .just(.setFeeList(feeList)),
                        .just(.setFilteredFeeList(sortedFeeList)),
                        .just(.setSelectedMarket(index))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: HomeStep) in
                        self?.steps.accept(step)
                    }
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
            let filteredFeeList: [CoinFee]
            if searchText.isEmpty {
                var sortedFeeList = currentState.feeList
                if self.currentState.coinSortOrder != SortOrder.none {
                    sortedFeeList = self.sortFeeList(sortedFeeList, by: \.coinTitle, order: self.currentState.coinSortOrder)
                }
                if self.currentState.feeSortOrder != SortOrder.none {
                    sortedFeeList = self.sortFeeList(sortedFeeList, by: \.fee, order: self.currentState.feeSortOrder)
                }
                filteredFeeList = sortedFeeList
            } else {
                filteredFeeList = currentState.feeList.filter { $0.coinTitle.lowercased().contains(searchText.lowercased()) }
            }
            return .concat([
                .just(.setSearchText(searchText)),
                .just(.setFilteredFeeList(filteredFeeList))
            ])
        case .clearButtonTapped:
            return .concat([
                .just(.setSearchText("")),
                .just(.setFilteredFeeList(currentState.feeList))
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
            let sortedFeeList = self.sortFeeList(currentState.filteredFeeList, by: \.coinTitle, order: newOrder)
            return .concat([
                .just(.setCoinSortOrder(newOrder)),
                .just(.setFilteredFeeList(sortedFeeList))
            ])
        case .sortByFee:
            let newOrder: SortOrder
            switch currentState.feeSortOrder {
            case .none:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            case .descending:
                newOrder = .none
            }
            let sortedFeeList = self.sortFeeList(currentState.filteredFeeList, by: \.fee, order: newOrder)
            return .concat([
                .just(.setFeeSortOrder(newOrder)),
                .just(.setFilteredFeeList(sortedFeeList))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setFeeList(let feeList):
            newState.feeList = feeList
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
            UserDefaults.standard.set(order, forKey: "marketOrderAtFee")
        case .setSearchText(let searchText):
            newState.searchText = searchText
        case .setFilteredFeeList(let filteredFeeList):
            newState.filteredFeeList = filteredFeeList
        case .setCoinSortOrder(let order):
            newState.coinSortOrder = order
            newState.feeSortOrder = .none
        case .setFeeSortOrder(let order):
            newState.coinSortOrder = .none
            newState.feeSortOrder = order
        }
        return newState
    }
    
    private func startTimer() {
        stopTimer()
        timerDisposable = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard UIApplication.shared.applicationState == .active else {
                    print("앱이 백그라운드 상태입니다. API 호출 중단")
                    return
                }
                self?.action.onNext(.loadFeeList)
            })
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
    
    private func sortFeeList(_ feeList: [CoinFee], by keyPath: PartialKeyPath<CoinFee>, order: SortOrder) -> [CoinFee] {
        var sortedFeeList = feeList
        
        sortedFeeList.sort {
            let lhs: Any
            let rhs: Any
            
            let actualKeyPath = order == .none ? \CoinFee.price : keyPath
            
            if keyPath == \CoinFee.fee, let lhsValue = $0[keyPath: actualKeyPath] as? String, let rhsValue = $1[keyPath: actualKeyPath] as? String {
                lhs = Double(lhsValue) ?? 0.0
                rhs = Double(rhsValue) ?? 0.0
            }
            else if keyPath == \CoinFee.price {
                lhs = $0[keyPath: keyPath] as? Double ?? 0.0
                rhs = $1[keyPath: keyPath] as? Double ?? 0.0
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
        
        return sortedFeeList
    }
    
    private func filterFeeList(priceList: [CoinFee], searchText: String) -> [CoinFee] {
        guard !searchText.isEmpty else { return priceList }
        return priceList.filter { $0.coinTitle.lowercased().contains(searchText.lowercased()) }
    }
}
