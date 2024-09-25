import ReactorKit
import RxCocoa
import RxFlow

class DetailCoinInfoReactor: ReactorKit.Reactor, Stepper {
    let disposeBag = DisposeBag()
    let initialState: State
    var steps = PublishRelay<Step>()
    var coinUseCase: CoinUseCase
    
    init(coinUseCase: CoinUseCase, market: String, coin: String){
        let unit = market == "UPBIT" || market == "BITHUMB" ? "KRW" : "USDT"
        let coinTitle = "\(coin)(\(unit))"
        self.coinUseCase = coinUseCase
        self.initialState = State(market: market, coin: coin, coinTitle: coinTitle)
    }
    
    enum Action {
        case backButtonTapped
        case setCoinPrice
        case selectItem(Int)
        case setPreviousIndex(Int)
    }
    
    enum Mutation {
        case setCoinPrice(String)
        case setSelectedItem(Int)
        case setPreviousIndex(Int)
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
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(HomeStep.popViewController)
            return .empty()
        case .selectItem(let index):
            return .just(.setSelectedItem(index))
        case .setPreviousIndex(let index):
            return .just(.setPreviousIndex(index))
        case .setCoinPrice:
            return self.coinUseCase.fetchOnlyOneCoinPrice(market: currentState.market, symbol: currentState.coin)
                .map{ [weak self] coinPrice in
                    var price: String
                    if self?.currentState.market == "UPBIT" || self?.currentState.market == "BITHUMB" {
                        price = "₩ \(coinPrice.price)"
                    }
                    else {
                        price = "$ \(coinPrice.price)"
                    }
                    return .setCoinPrice(price)
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
        }
        return newState
    }
}
