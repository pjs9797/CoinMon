import ReactorKit
import RxCocoa
import RxFlow

class PremiumReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let selectDepartureMarketRelay = PublishRelay<String>()
    let selectArrivalMarketRelay = PublishRelay<String>()
    private var timerDisposable: Disposable?
    private let coinUseCase: CoinUseCase
    
    init(coinUseCase: CoinUseCase){
        self.coinUseCase = coinUseCase
    }
    
    enum Action {
        case startTimer
        case stopTimer
        case loadPremiumList
        case departureMarketButtonTapped
        case arrivalMarketButtonTapped
        case setDepartureMarket(String)
        case setArrivalMarket(String)
        case sortByCoin
        case sortByPremium
    }
    
    enum Mutation {
        case setDepartureMarket(String)
        case setArrivalMarket(String)
        case setPremiumList([CoinPremium])
        case setFilteredPremiumList([CoinPremium])
        case setCoinSortOrder(SortOrder)
        case setPremiumSortOrder(SortOrder)
    }
    
    struct State {
        var premiumList: [CoinPremium] = []
        var departureMarketButtonTitle: String = "Upbit"
        var arrivalMarketButtonTitle: String = "Binance"
        var filteredpremiumList: [CoinPremium] = []
        var coinSortOrder: SortOrder = .none
        var premiumSortOrder: SortOrder = .none
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startTimer:
            startTimer()
            return .empty()
        case .stopTimer:
            stopTimer()
            return .empty()
        case .loadPremiumList:
            return coinUseCase.fetchCoinPremiumList(departureMarket: currentState.departureMarketButtonTitle, arrivalMarket: currentState.arrivalMarketButtonTitle)
                .flatMap { [weak self] premiumList -> Observable<Mutation> in
                    var sortedPremiumList = premiumList
                    if self?.currentState.coinSortOrder != SortOrder.none {
                        sortedPremiumList = self?.sortPremiumList(sortedPremiumList, by: \.coinTitle, order: self?.currentState.coinSortOrder ?? .none) ?? premiumList
                    }
                    if self?.currentState.premiumSortOrder != SortOrder.none {
                        sortedPremiumList = self?.sortPremiumList(sortedPremiumList, by: \.premium, order: self?.currentState.premiumSortOrder ?? .none) ?? premiumList
                    }
                    return .concat([
                        .just(.setPremiumList(premiumList)),
                        .just(.setFilteredPremiumList(sortedPremiumList))
                    ])
                }
                .catch { [weak self] error in
                    self?.steps.accept(HomeStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .departureMarketButtonTapped:
            self.steps.accept(HomeStep.presentToSelectDepartureMarketViewController(selectedMarketRelay: selectDepartureMarketRelay, selectedMarketLocalizationKey: currentState.departureMarketButtonTitle))
            return .empty()
        case .arrivalMarketButtonTapped:
            self.steps.accept(HomeStep.presentToSelectArrivalMarketViewController(selectedMarketRelay: selectArrivalMarketRelay, selectedMarketLocalizationKey: currentState.arrivalMarketButtonTitle))
            return .empty()
        case .setDepartureMarket(let market):
            return .just(.setDepartureMarket(market))
        case .setArrivalMarket(let market):
            return .just(.setArrivalMarket(market))
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
            let sortedPremiumList = self.sortPremiumList(currentState.filteredpremiumList, by: \.coinTitle, order: newOrder)
            return .concat([
                .just(.setCoinSortOrder(newOrder)),
                .just(.setFilteredPremiumList(sortedPremiumList))
            ])
        case .sortByPremium:
            let newOrder: SortOrder
            switch currentState.premiumSortOrder {
            case .none:
                newOrder = .ascending
            case .ascending:
                newOrder = .descending
            case .descending:
                newOrder = .none
            }
            let sortedPremiumList = self.sortPremiumList(currentState.filteredpremiumList, by: \.premium, order: newOrder)
            return .concat([
                .just(.setPremiumSortOrder(newOrder)),
                .just(.setFilteredPremiumList(sortedPremiumList))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setDepartureMarket(let market):
            newState.departureMarketButtonTitle = market
        case .setArrivalMarket(let market):
            newState.arrivalMarketButtonTitle = market
        case .setPremiumList(let premiumList):
            newState.premiumList = premiumList
        case .setFilteredPremiumList(let filteredPremiumList):
            newState.filteredpremiumList = filteredPremiumList
        case .setCoinSortOrder(let order):
            newState.coinSortOrder = order
            newState.premiumSortOrder = .none
        case .setPremiumSortOrder(let order):
            newState.premiumSortOrder = order
            newState.coinSortOrder = .none
        }
        return newState
    }
    
    private func startTimer() {
        stopTimer()
        timerDisposable = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.action.onNext(.loadPremiumList)
            })
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
    
    private func sortPremiumList(_ premium: [CoinPremium], by keyPath: PartialKeyPath<CoinPremium>, order: SortOrder) -> [CoinPremium] {
        var sortedPremiumList = premium
        
        sortedPremiumList.sort {
            let lhs: Any
            let rhs: Any
            
            let actualKeyPath = order == .none ? \CoinPremium.price : keyPath
            
            if keyPath == \CoinPremium.premium, let lhsValue = $0[keyPath: actualKeyPath] as? String, let rhsValue = $1[keyPath: actualKeyPath] as? String {
                lhs = Double(lhsValue) ?? 0.0
                rhs = Double(rhsValue) ?? 0.0
            }
            else if keyPath == \CoinPremium.price {
                lhs = $0[keyPath: actualKeyPath] as? Double ?? 0.0
                rhs = $1[keyPath: actualKeyPath] as? Double ?? 0.0
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
        
        return sortedPremiumList
    }
}
