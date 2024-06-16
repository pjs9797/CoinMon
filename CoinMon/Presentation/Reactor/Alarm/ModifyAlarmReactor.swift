import ReactorKit
import RxCocoa
import RxFlow

class ModifyAlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let alarmUseCase: AlarmUseCase
    private let coinUseCase: CoinUseCase
    let selectFirstAlarmConditionRelay = PublishRelay<Int>()
    let selectSecondAlarmConditionRelay = PublishRelay<String>()
    
    init(alarmUseCase: AlarmUseCase, coinUseCase: CoinUseCase, market: String, alarm: Alarm){
        self.alarmUseCase = alarmUseCase
        self.coinUseCase = coinUseCase
        
        let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
        let cycleForAPI = alarm.cycle
        var cycle = ""
        switch cycleForAPI {
        case "0":
            cycle = LocalizationManager.shared.localizedString(forKey: "한 번만")
        case "1":
            cycle = LocalizationManager.shared.localizedString(forKey: "1분 간격")
        case "5":
            cycle = LocalizationManager.shared.localizedString(forKey: "5분 간격")
        case "10":
            cycle = LocalizationManager.shared.localizedString(forKey: "10분 간격")
        case "30":
            cycle = LocalizationManager.shared.localizedString(forKey: "30분 간격")
        case "60":
            cycle = LocalizationManager.shared.localizedString(forKey: "1시간 간격")
        default:
            cycle = "0"
        }
        let useYn = alarm.isOn ? "Y" : "N"
        
        initialState = State(alarmId: alarm.alarmId, market: market, coinTitle: alarm.coinTitle, currentPriceUnit: unit, currentPrice: "", setPriceUnit: unit, setPrice: alarm.setPrice, cycle: cycle, cycleForAPI: cycleForAPI, useYn: useYn)
    }
    
    enum Action {
        case backButtonTapped
        case deleteButtonTapped
        case comparePriceButtonTapped
        case cycleButtonTapped
        case completeButtonTapped
        
        case updateCurrentPrice
        case updateSetPrice(String)
        case setComparePrice(Int)
        case setCycle(String)
    }
    
    enum Mutation {
        case setCurrentPriceUnit(String)
        case setCurrentPrice(String)
        case setSetPriceUnit(String)
        case setSetPrice(String)
        case setComparePrice(Int)
        case setCycle(String)
        case setCycleForAPI(String)
    }
    
    struct State {
        var alarmId: Int
        var market: String
        var coinTitle: String
        var currentPriceUnit: String
        var currentPrice: String
        var setPriceUnit: String
        var setPrice: String
        var comparePrice: Int? = nil
        var cycle: String
        var cycleForAPI: String
        var useYn: String
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .deleteButtonTapped:
            return alarmUseCase.deleteAlarm(pushId: currentState.alarmId)
                .flatMap { [weak self] _ -> Observable<Mutation> in
                    self?.steps.accept(AlarmStep.popViewController)
                    return .empty()
                }
                .catch { [weak self] _ in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .comparePriceButtonTapped:
            self.steps.accept(AlarmStep.presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: selectFirstAlarmConditionRelay))
            return .empty()
        case .cycleButtonTapped:
            self.steps.accept(AlarmStep.presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: selectSecondAlarmConditionRelay))
            return .empty()
        case .completeButtonTapped:
            var filter = "UP"
            if let currentPrice = Double(currentState.currentPrice ), let setPrice = Double(currentState.setPrice ) {
                if currentPrice > setPrice {
                    filter = "DOWN"
                }
            }
            return alarmUseCase.updateAlarm(pushId: currentState.alarmId, market: currentState.market , symbol: currentState.coinTitle , targetPrice: currentState.setPrice , frequency: currentState.cycleForAPI, useYn: currentState.useYn, filter: filter)
                .flatMap { [weak self] _ -> Observable<Mutation> in
                    self?.steps.accept(AlarmStep.popViewController)
                    return .empty()
                }
                .catch { [weak self] _ in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .updateCurrentPrice:
            return coinUseCase.fetchOneCoinPrice(market: currentState.market, symbol: currentState.coinTitle)
                .flatMap { coin -> Observable<Mutation> in
                    return .just(.setCurrentPrice(coin.price))
                }
                .catch { [weak self] _ in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .updateSetPrice(let price):
            if price == "" {
                return .empty()
            }
            let filteredPrice = filterPrice(price: price)
            return .concat([
                .just(.setSetPrice(filteredPrice))
            ])
        case .setComparePrice(let index):
            let newPrice = calculateSetPrice(currentPrice: currentState.currentPrice, index: index)
            return .concat([
                .just(.setComparePrice(index)),
                .just(.setSetPrice(newPrice))
            ])
        case .setCycle(let condition):
            var cycleForAPI = "0"
            switch condition {
            case LocalizationManager.shared.localizedString(forKey: "한 번만"):
                cycleForAPI = "0"
            case LocalizationManager.shared.localizedString(forKey: "1분 간격"):
                cycleForAPI = "1"
            case LocalizationManager.shared.localizedString(forKey: "5분 간격"):
                cycleForAPI = "5"
            case LocalizationManager.shared.localizedString(forKey: "10분 간격"):
                cycleForAPI = "10"
            case LocalizationManager.shared.localizedString(forKey: "30분 간격"):
                cycleForAPI = "30"
            case LocalizationManager.shared.localizedString(forKey: "1시간 간격"):
                cycleForAPI = "60"
            default:
                cycleForAPI = "0"
            }
            return .concat([
                .just(.setCycle(condition)),
                .just(.setCycleForAPI(cycleForAPI))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCurrentPriceUnit(let unit):
            newState.currentPriceUnit = unit
        case .setCurrentPrice(let currentPrice):
            newState.currentPrice = currentPrice
        case .setSetPriceUnit(let unit):
            newState.setPriceUnit = unit
        case .setSetPrice(let setPrice):
            newState.setPrice = setPrice
        case .setComparePrice(let comparePrice):
            newState.comparePrice = comparePrice
        case .setCycle(let cycle):
            newState.cycle = cycle
        case .setCycleForAPI(let cycleForAPI):
            newState.cycleForAPI = cycleForAPI
        }
        return newState
    }
    
    func filterPrice(price: String) -> String {
        let filteredText = price.filter { $0.isNumber || $0 == "." }
        var resultText = ""
        var decimalFound = false
        
        for char in filteredText {
            if char == "." {
                if decimalFound {
                    continue
                } else {
                    decimalFound = true
                }
            }
            resultText.append(char)
        }
        
        if resultText.last == "." {
            resultText.removeLast()
        }
        
        if resultText.count > 10 {
            resultText = String(resultText.prefix(10))
            if resultText.last == "." {
                resultText.removeLast()
            }
        }
        
        return resultText
    }
    
    private func calculateSetPrice(currentPrice: String, index: Int) -> String {
        guard let priceValue = Double(currentPrice) else {
            return ""
        }
        
        let newValue = String(priceValue * (1 + Double(index) / 100.0)).prefix(10)
        return String(newValue)
    }
}
