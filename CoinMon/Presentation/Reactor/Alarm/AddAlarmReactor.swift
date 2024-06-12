import ReactorKit
import RxCocoa
import RxFlow

class AddAlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let selectMarketRelay = PublishRelay<String>()
    let selectCoinRelay = PublishRelay<(String,String)>()
    let selectFirstAlarmConditionRelay = PublishRelay<Int>()
    let selectSecondAlarmConditionRelay = PublishRelay<Int>()
    
    init() {
    }
    
    enum Action {
        case backButtonTapped
        case marketButtonTapped
        case coinButtonTapped
        case comparePriceButtonTapped
        case cycleButtonTapped
        
        case setMarket(String)
        case setCoin(String,String)
        case updateSetPrice(String)
        case setComparePrice(Int)
        case setCycle(Int)
    }
    
    enum Mutation {
        case setMarket(String)
        case setCoinTitle(String)
        case setCoinPrice(String)
        case setCurrentPrice(String)
        case setSetPrice(String)
        case setComparePrice(String)
        case setCycle(String)
    }
    
    struct State {
        var market: String? = nil
        var coinTitle: String? = nil
        var coinPrice: String? = nil
        var currentPrice: String? = nil
        var setPrice: String? = nil
        var comparePrice: String? = nil
        var cycle: String? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .marketButtonTapped:
            self.steps.accept(AlarmStep.presentToSelectMarketViewController(selectedMarketRelay: selectMarketRelay))
            return .empty()
        case .coinButtonTapped:
            self.steps.accept(AlarmStep.navigateToSelectCoinViewController(selectedCoinRelay: selectCoinRelay))
            return .empty()
        case .comparePriceButtonTapped:
            self.steps.accept(AlarmStep.presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: selectFirstAlarmConditionRelay))
            return .empty()
        case .cycleButtonTapped:
            self.steps.accept(AlarmStep.presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: selectSecondAlarmConditionRelay))
            return .empty()
            
        case .setMarket(let market):
            return .just(.setMarket(market))
        case .setCoin(let coin, let price):
            var adjustedPrice = price
            if let market = currentState.market {
                if market == "Upbit" || market == "Bithumb" {
                    adjustedPrice += " KRW"
                } else {
                    adjustedPrice += " USDT"
                }
            }
            return .concat([
                .just(.setCoinTitle(coin)),
                .just(.setCoinPrice(adjustedPrice)),
                .just(.setCurrentPrice(price))
            ])
        case .updateSetPrice(let price):
            var adjustedPrice = String(price.prefix(10))
            if let market = currentState.market {
                if market == "Upbit" || market == "Bithumb" {
                    adjustedPrice += " KRW"
                } else {
                    adjustedPrice += " USDT"
                }
            }
            return .just(.setSetPrice(adjustedPrice))
        case .setComparePrice(let index):
            return .empty()
        case .setCycle(let index):
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMarket(let market):
            newState.market = market
        case .setCoinTitle(let coinTitle):
            newState.coinTitle = coinTitle
        case .setCoinPrice(let coinPrice):
            newState.coinPrice = coinPrice
        case .setCurrentPrice(let currentPrice):
            newState.currentPrice = currentPrice
        case .setSetPrice(let setPrice):
            newState.setPrice = setPrice
        case .setComparePrice(let comparePrice):
            newState.comparePrice = comparePrice
        case .setCycle(let cycle):
            newState.cycle = cycle
        }
        return newState
    }
}
