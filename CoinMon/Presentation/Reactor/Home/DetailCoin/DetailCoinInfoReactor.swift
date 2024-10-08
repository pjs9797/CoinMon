import Foundation
import ReactorKit
import RxCocoa
import RxFlow

class DetailCoinInfoReactor: ReactorKit.Reactor, Stepper {
    let disposeBag = DisposeBag()
    let initialState: State
    var steps = PublishRelay<Step>()
    private let coinUseCase: CoinUseCase
    private let favoritesUseCase: FavoritesUseCase
    
    init(coinUseCase: CoinUseCase, favoritesUseCase: FavoritesUseCase, market: String, coin: String){
        let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
        let coinTitle = "\(coin)(\(unit))"
        self.coinUseCase = coinUseCase
        self.favoritesUseCase = favoritesUseCase
        self.initialState = State(market: market, coin: coin, coinTitle: coinTitle)
    }
    
    enum Action {
        case toastButtonTapped
        case searchButtonTapped
        case favoriteButtonTapped
        case backButtonTapped
        case setCoinDetailBaseInfo
        case selectItem(Int)
        case setPreviousIndex(Int)
    }
    
    enum Mutation {
        case setSelectedItem(Int)
        case setPreviousIndex(Int)
        case setCoinPrice(String)
        case setYesterdayComparisonInfo(String)
        case setFavorites(Bool)
        case setPush(Bool)
        case setfavoritesId(Int?)
    }
    
    struct State {
        var selectedItem: Int = 0
        var previousIndex: Int = 0
        var categories: [String] = [
            LocalizationManager.shared.localizedString(forKey: "차트"),
            LocalizationManager.shared.localizedString(forKey: "종목정보"),
            LocalizationManager.shared.localizedString(forKey: "커뮤니티")
        ]
        var market: String
        var coin: String
        var coinTitle: String
        var coinPrice: String = ""
        var yesterdayComparisonInfo: String = ""
        var isFavorites: Bool = false
        var isPush: Bool = false
        var favoritesId: Int?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toastButtonTapped:
            NotificationCenter.default.post(name: .seeFavorites, object: nil)
            self.steps.accept(HomeStep.popViewController)
            return .empty()
        case .searchButtonTapped:
            self.steps.accept(HomeStep.navigateToSelectCoinAtDetailViewController(market: currentState.market))
            return .empty()
        case .favoriteButtonTapped:
            if currentState.isFavorites {
                if let id = currentState.favoritesId {
                    return self.favoritesUseCase.deleteFavorites(favoritesId: String(id))
                        .flatMap { resultCode -> Observable<Mutation> in
                            if resultCode == "200" {
                                NotificationCenter.default.post(name: .favoritesDeleted, object: nil)
                                return .just(.setFavorites(false))
                            }
                            return .empty()
                        }
                        .catch { [weak self] error in
                            ErrorHandler.handle(error) { (step: HomeStep) in
                                self?.steps.accept(step)
                            }
                            return .empty()
                        }
                }
                else {
                    return .empty()
                }
            }
            else {
                return self.favoritesUseCase.createFavorites(market: currentState.market, symbol: currentState.coin)
                    .flatMap { resultCode -> Observable<Mutation> in
                        if resultCode == "200" {
                            NotificationCenter.default.post(name: .favoritesAdded, object: nil)
                            return Observable.concat([
                                .just(.setFavorites(true)),
                                self.coinUseCase.fetchCoinDetailBaseInfo(exchange: self.currentState.market, symbol: self.currentState.coin)
                                    .map { coinDetailBaseInfo in
                                            .setfavoritesId(coinDetailBaseInfo.favoritesId)
                                    }
                            ])
                        }
                        return .empty()
                    }
                    .catch { [weak self] error in
                        ErrorHandler.handle(error) { (step: HomeStep) in
                            self?.steps.accept(step)
                        }
                        return .empty()
                    }
            }
            
        case .backButtonTapped:
            self.steps.accept(HomeStep.popViewController)
            return .empty()
        case .selectItem(let index):
            return .just(.setSelectedItem(index))
        case .setPreviousIndex(let index):
            return .just(.setPreviousIndex(index))
        case .setCoinDetailBaseInfo:
            return Observable.zip(
                self.coinUseCase.fetchOnlyOneCoinPrice(market: currentState.market, symbol: currentState.coin),
                self.coinUseCase.fetchCoinDetailBaseInfo(exchange: currentState.market, symbol: currentState.coin)
            )
            .flatMap { [weak self] (coinPrice, coinDetailBaseInfo) -> Observable<Mutation> in
                
                let currentPrice = Double(coinPrice.price) ?? 0
                let lastPrice1 = Double(coinDetailBaseInfo.lastPrice1) ?? 0
                
                let isIncrease = currentPrice >= lastPrice1
                let sign = isIncrease ? "+" : "-"
                
                let currencySymbol = self?.currentState.market == "Upbit" || self?.currentState.market == "Bithumb" ? "₩" : "$"
                
                let priceFormatter = NumberFormatter()
                priceFormatter.numberStyle = .decimal
                priceFormatter.maximumFractionDigits = self?.getDecimalPlaces(coinPrice.price) ?? 0
                let formattedPrice = priceFormatter.string(from: NSNumber(value: currentPrice)) ?? coinPrice.price
                let price = "\(currencySymbol) \(formattedPrice)"
                
                let priceDifference = abs(currentPrice - lastPrice1)
                let percentageDifference = (priceDifference / lastPrice1) * 100
                
                let priceDifferenceFormatter = NumberFormatter()
                priceDifferenceFormatter.numberStyle = .decimal
                priceDifferenceFormatter.maximumFractionDigits = self?.getDecimalPlaces(coinPrice.price) ?? 0
                let formattedPriceDifference = priceDifferenceFormatter.string(from: NSNumber(value: priceDifference)) ?? ""
                
                let percentageFormatter = NumberFormatter()
                percentageFormatter.numberStyle = .decimal
                percentageFormatter.maximumFractionDigits = 2
                let formattedPercentage = percentageFormatter.string(from: NSNumber(value: percentageDifference)) ?? ""
                
                let yesterdayComparisonInfo = LocalizationManager.shared.localizedString(
                    forKey: "어제대비",
                    arguments: sign, currencySymbol, formattedPriceDifference, "\(sign)\(formattedPercentage)%"
                )
                
                return Observable.concat([
                    .just(.setCoinPrice(price)),
                    .just(.setYesterdayComparisonInfo(yesterdayComparisonInfo)),
                    .just(.setFavorites(coinDetailBaseInfo.isFavorites)),
                    .just(.setPush(coinDetailBaseInfo.isPush)),
                    .just(.setfavoritesId(coinDetailBaseInfo.favoritesId))
                ])
            }
            .catch { [weak self] error in
                ErrorHandler.handle(error) { (step: HomeStep) in
                    self?.steps.accept(step)
                }
                return .empty()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectedItem(let index):
            newState.selectedItem = index
        case .setPreviousIndex(let index):
            newState.previousIndex = index
        case .setCoinPrice(let price):
            newState.coinPrice = price
        case .setYesterdayComparisonInfo(let info):
            newState.yesterdayComparisonInfo = info
        case .setFavorites(let isFavorites):
            newState.isFavorites = isFavorites
        case .setPush(let isPush):
            newState.isPush = isPush
        case .setfavoritesId(let id):
            newState.favoritesId = id
        }
        return newState
    }
    
    private func getDecimalPlaces(_ number: String) -> Int {
        let components = number.components(separatedBy: ".")
        return components.count > 1 ? components[1].count : 0
    }
}
