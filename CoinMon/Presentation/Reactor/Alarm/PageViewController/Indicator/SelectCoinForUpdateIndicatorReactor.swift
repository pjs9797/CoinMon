import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class SelectCoinForUpdateIndicatorReactor: ReactorKit.Reactor, Stepper {
    let disposeBag = DisposeBag()
    let initialState: State
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    let selectCoinRelay: BehaviorRelay<[UpdateSelectedIndicatorCoin]>
    
    init(indicatorUseCase: IndicatorUseCase, indicatorId: String, indicatorName: String, isPremium: Bool, selectCoinRelay: BehaviorRelay<[UpdateSelectedIndicatorCoin]>) {
        self.initialState = State(indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium)
        self.indicatorUseCase = indicatorUseCase
        self.selectCoinRelay = selectCoinRelay
    }
    
    enum Action {
        // 버튼 탭
        case backButtonTapped
        case resetButtonTapped
        case selectedButtonTapped
        case checkButtonTapped(indicatorCoinId: String)
        case deleteButtonTapped(indicatorCoinId: String)
        
        // 검색
        case updateSearchText(String)
        case clearButtonTapped
        
        // 코인
        case loadUpdateSelectedIndicatorCoin([UpdateSelectedIndicatorCoin])
        case loadIndicatorCoinPriceChange
        case sortByCoin
        case sortByPrice
        case sortByChange
    }
    
    enum Mutation {
        
        // 검색
        case setSearchText(String)
        
        case setInitialcheckedCoinList([UpdateSelectedIndicatorCoin])
        case setCheckedCoinList([UpdateSelectedIndicatorCoin])
        
        // 코인
        case setIndicatorCoinPriceChangeList([IndicatorCoinPriceChange])
        case setUnit(String)
        case setFilteredindicatorCoinPriceChangeList([IndicatorCoinPriceChange])
        case setCoinSortOrder(SortOrder)
        case setPriceSortOrder(SortOrder)
        case setChangeSortOrder(SortOrder)
    }
    
    struct State {
        var indicatorId: String
        var indicatorName: String
        var isPremium: Bool
        
        // 검색
        var searchText: String = ""
        
        var initialcheckedCoinList: [UpdateSelectedIndicatorCoin] = []
        var checkedCoinList: [UpdateSelectedIndicatorCoin] = []
        
        // 코인
        var unit: String = "USDT"
        var indicatorCoinPriceChangeList: [IndicatorCoinPriceChange] = []
        var filteredindicatorCoinPriceChangeList: [IndicatorCoinPriceChange] = []
        var coinSortOrder: SortOrder = .none
        var priceSortOrder: SortOrder = .none
        var changeSortOrder: SortOrder = .none
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            // 버튼 탭
        case .backButtonTapped:
            self.selectCoinRelay.accept(currentState.initialcheckedCoinList)
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .resetButtonTapped:
            let filteredList = currentState.filteredindicatorCoinPriceChangeList.map { listItem -> IndicatorCoinPriceChange in
                var updatedItem = listItem
                updatedItem.isChecked = false
                return updatedItem
            }
            
            return .concat([
                .just(.setFilteredindicatorCoinPriceChangeList(filteredList)),
                .just(.setCheckedCoinList([]))
            ])
        case .selectedButtonTapped:
            self.selectCoinRelay.accept(currentState.checkedCoinList.sorted{ $0.indicatorCoinId < $1.indicatorCoinId })
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .checkButtonTapped(let indicatorCoinId):
            let filteredList = currentState.filteredindicatorCoinPriceChangeList.map { listItem -> IndicatorCoinPriceChange in
                var updatedItem = listItem
                if updatedItem.indicatorCoinId == indicatorCoinId {
                    updatedItem.isChecked.toggle()
                }
                return updatedItem
            }
            let checkedCoinList = filteredList.filter{ $0.isChecked }
                .map { UpdateSelectedIndicatorCoin(indicatorCoinId: Int($0.indicatorCoinId)!, coinTitle: $0.coinTitle, isPinned: $0.isPinned, isChecked: $0.isChecked) }
            
            return .concat([
                .just(.setCheckedCoinList(checkedCoinList)),
                .just(.setFilteredindicatorCoinPriceChangeList(filteredList))
            ])
        case .deleteButtonTapped(let indicatorCoinId):
            let filteredList = currentState.filteredindicatorCoinPriceChangeList.map { listItem -> IndicatorCoinPriceChange in
                var updatedItem = listItem
                if updatedItem.indicatorCoinId == indicatorCoinId {
                    updatedItem.isChecked = false
                }
                return updatedItem
            }
            
            let checkedCoinList = filteredList.filter{ $0.isChecked }
                .map { UpdateSelectedIndicatorCoin(indicatorCoinId: Int($0.indicatorCoinId)!, coinTitle: $0.coinTitle, isPinned: $0.isPinned , isChecked: $0.isChecked) }

            return .concat([
                .just(.setFilteredindicatorCoinPriceChangeList(filteredList)),
                .just(.setCheckedCoinList(checkedCoinList))
            ])
            
            // 검색
        case .updateSearchText(let searchText):
            let filteredList: [IndicatorCoinPriceChange]
            if searchText.isEmpty {
                var sortedList = currentState.indicatorCoinPriceChangeList
                if currentState.coinSortOrder != .none {
                    sortedList = sortIndicatorCoinPriceChangeList(sortedList, by: \.coinTitle, order: currentState.coinSortOrder)
                }
                else if currentState.priceSortOrder != .none {
                    sortedList = sortIndicatorCoinPriceChangeList(sortedList, by: \.price, order: currentState.priceSortOrder)
                }
                else if currentState.changeSortOrder != .none {
                    sortedList = sortIndicatorCoinPriceChangeList(sortedList, by: \.change, order: currentState.changeSortOrder)
                }
                filteredList = sortedList
            } else {
                filteredList = currentState.indicatorCoinPriceChangeList.filter { $0.coinTitle.lowercased().contains(searchText.lowercased()) }
            }
            return .concat([
                .just(.setSearchText(searchText)),
                .just(.setFilteredindicatorCoinPriceChangeList(filteredList))
            ])
        case .clearButtonTapped:
            return .concat([
                .just(.setSearchText("")),
                .just(.setFilteredindicatorCoinPriceChangeList(currentState.indicatorCoinPriceChangeList))
            ])
            
            // 코인
        case .loadUpdateSelectedIndicatorCoin(let updateSelectedIndicatorCoin):
            return .concat([
                .just(.setInitialcheckedCoinList(updateSelectedIndicatorCoin)),
                .just(.setCheckedCoinList(updateSelectedIndicatorCoin)),
                self.indicatorUseCase.getIndicatorCoinList(indicatorId: currentState.indicatorId)
                    .flatMap { indicatorCoinPriceChange -> Observable<Mutation> in
                        let updatedList = indicatorCoinPriceChange.map { listItem -> IndicatorCoinPriceChange in
                            var updatedItem = listItem
                            if let selectedCoin = updateSelectedIndicatorCoin.first(where: { $0.indicatorCoinId == Int(listItem.indicatorCoinId)! }) {
                                updatedItem.isPinned = selectedCoin.isPinned
                                updatedItem.isChecked = true
                            }
                            return updatedItem
                        }
                        return .concat([
                            .just(.setIndicatorCoinPriceChangeList(updatedList)),
                            .just(.setFilteredindicatorCoinPriceChangeList(updatedList))
                        ])
                    }
            ])
        case .loadIndicatorCoinPriceChange:
            let selectedCoins = currentState.initialcheckedCoinList
            return self.indicatorUseCase.getIndicatorCoinList(indicatorId: currentState.indicatorId)
                .flatMap { indicatorCoinPriceChange -> Observable<Mutation> in
                    let updatedList = indicatorCoinPriceChange.map { listItem -> IndicatorCoinPriceChange in
                        var updatedItem = listItem
                        if let selectedCoin = selectedCoins.first(where: { $0.indicatorCoinId == Int(listItem.indicatorCoinId)! }) {
                            updatedItem.isPinned = selectedCoin.isPinned
                            updatedItem.isChecked = true
                        }
                        return updatedItem
                    }
                    
                    return .concat([
                        .just(.setIndicatorCoinPriceChangeList(updatedList)),
                        .just(.setFilteredindicatorCoinPriceChangeList(updatedList))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
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
            let sortedList = self.sortIndicatorCoinPriceChangeList(currentState.filteredindicatorCoinPriceChangeList, by: \.coinTitle, order: newOrder)
            return .concat([
                .just(.setCoinSortOrder(newOrder)),
                .just(.setFilteredindicatorCoinPriceChangeList(sortedList))
            ])
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
            let sortedList = self.sortIndicatorCoinPriceChangeList(currentState.filteredindicatorCoinPriceChangeList, by: \.price, order: newOrder)
            return .concat([
                .just(.setCoinSortOrder(newOrder)),
                .just(.setFilteredindicatorCoinPriceChangeList(sortedList))
            ])
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
            let sortedList = self.sortIndicatorCoinPriceChangeList(currentState.filteredindicatorCoinPriceChangeList, by: \.change, order: newOrder)
            return .concat([
                .just(.setCoinSortOrder(newOrder)),
                .just(.setFilteredindicatorCoinPriceChangeList(sortedList))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSearchText(let searchText):
            newState.searchText = searchText
        case .setUnit(let unit):
            newState.unit = unit
        case .setInitialcheckedCoinList(let checkedCoinList):
            newState.initialcheckedCoinList = checkedCoinList
        case .setCheckedCoinList(let checkedCoinList):
            newState.checkedCoinList = checkedCoinList
        case .setIndicatorCoinPriceChangeList(let list):
            newState.indicatorCoinPriceChangeList = list
        case .setFilteredindicatorCoinPriceChangeList(let filteredList):
            newState.filteredindicatorCoinPriceChangeList = filteredList
        case .setCoinSortOrder(let order):
            newState.coinSortOrder = order
            newState.priceSortOrder = .none
            newState.changeSortOrder = .none
        case .setPriceSortOrder(let order):
            newState.coinSortOrder = .none
            newState.priceSortOrder = order
            newState.changeSortOrder = .none
        case .setChangeSortOrder(let order):
            newState.coinSortOrder = .none
            newState.priceSortOrder = .none
            newState.changeSortOrder = order
        }
        return newState
    }
    
    private func sortIndicatorCoinPriceChangeList(_ indicatorCoinPriceChangeList: [IndicatorCoinPriceChange], by keyPath: PartialKeyPath<IndicatorCoinPriceChange>, order: SortOrder) -> [IndicatorCoinPriceChange] {
        var sortedList = indicatorCoinPriceChangeList
        
        sortedList.sort {
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
            else {
                lhs = $0[keyPath: actualKeyPath] as! String
                rhs = $1[keyPath: actualKeyPath] as! String
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
        
        return sortedList
    }
}

