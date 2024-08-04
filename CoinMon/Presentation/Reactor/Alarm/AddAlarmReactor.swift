import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class AddAlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    let selectMarketRelay = PublishRelay<String>()
    let selectCoinRelay = PublishRelay<(String,String)>()
    let selectFirstAlarmConditionRelay = PublishRelay<Int>()
    let selectSecondAlarmConditionRelay = PublishRelay<String>()
    private let alarmUseCase: AlarmUseCase
    
    init(alarmUseCase: AlarmUseCase){
        self.alarmUseCase = alarmUseCase
    }
    
    enum Action {
        case backButtonTapped
        case marketButtonTapped
        case coinButtonTapped
        case comparePriceButtonTapped
        case cycleButtonTapped
        case completeButtonTapped
        
        case setMarket(String)
        case setCoin(String,String)
        case updateSetPrice(String)
        case setComparePrice(Int)
        case setCycle(String)
    }
    
    enum Mutation {
        case setMarket(String)
        case setCoinTitle(String?)
        case setCurrentPriceUnit(String?)
        case setCurrentPrice(String?)
        case setSetPriceUnit(String?)
        case setSetPrice(String?)
        case setComparePrice(Int?)
        case setCycle(String)
        case setCycleForAPI(String)
    }
    
    struct State {
        var market: String? = nil
        var coinTitle: String? = nil
        var currentPriceUnit: String? = nil
        var currentPrice: String? = nil
        var setPriceUnit: String? = nil
        var setPrice: String? = nil
        var comparePrice: Int? = nil
        var cycle: String? = nil
        var cycleForAPI: String = "0"
        var isCompleteButtonEnable: Bool = false
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .marketButtonTapped:
            self.steps.accept(AlarmStep.presentToSelectMarketViewController(selectedMarketRelay: selectMarketRelay, selectedMarketLocalizationKey: currentState.market ?? ""))
            return .empty()
        case .coinButtonTapped:
            self.steps.accept(AlarmStep.navigateToSelectCoinViewController(selectedCoinRelay: selectCoinRelay, market: currentState.market ?? "BINANCE"))
            return .empty()
        case .comparePriceButtonTapped:
            self.steps.accept(AlarmStep.presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: selectFirstAlarmConditionRelay))
            return .empty()
        case .cycleButtonTapped:
            self.steps.accept(AlarmStep.presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: selectSecondAlarmConditionRelay))
            return .empty()
        case .completeButtonTapped:
            var filter = "UP"
            if let currentPrice = Double(currentState.currentPrice ?? "0"), let setPrice = Double(currentState.setPrice ?? "0") {
                if currentPrice > setPrice {
                    filter = "DOWN"
                }
            }
            return alarmUseCase.createAlarm(market: currentState.market ?? "", symbol: currentState.coinTitle ?? "", targetPrice: currentState.setPrice ?? "", frequency: currentState.cycleForAPI, useYn: "Y", filter: filter)
                .flatMap { [weak self] _ -> Observable<Mutation> in
                    self?.steps.accept(AlarmStep.popViewController)
                    return .empty()
                }
                .catch { [weak self] _ in
                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
                    return .empty()
                }
        case .setMarket(let market):
            return .concat([
                .just(.setMarket(market)),
                .just(.setCoinTitle(nil)),
                .just(.setCurrentPriceUnit(nil)),
                .just(.setCurrentPrice(nil)),
                .just(.setSetPriceUnit(nil)),
                .just(.setSetPrice(nil)),
                .just(.setComparePrice(nil))
            ])
        case .setCoin(let coin, let price):
            let unit = setUnit()
            return .concat([
                .just(.setCoinTitle(coin)),
                .just(.setCurrentPriceUnit(unit)),
                .just(.setCurrentPrice(price)),
                .just(.setSetPriceUnit(unit)),
                .just(.setSetPrice(price)),
            ])
        case .updateSetPrice(let price):
            if price == "" {
                return .empty()
            }
            let filteredPrice = filterPrice(price: price)
            return .concat([
                .just(.setSetPrice(filteredPrice))
            ])
        case .setComparePrice(let index):
            if let currentPrice = currentState.currentPrice{
                let newPrice = calculateSetPrice(currentPrice: currentPrice, index: index)
                return .concat([
                    .just(.setComparePrice(index)),
                    .just(.setSetPrice(newPrice))
                ])
            } else {
                return .empty()
            }
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
        case .setMarket(let market):
            newState.market = market
        case .setCoinTitle(let coinTitle):
            newState.coinTitle = coinTitle
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
        newState.isCompleteButtonEnable = (newState.market != nil) && (newState.currentPrice != nil) && (newState.setPrice != nil) && (newState.cycle != nil)
        return newState
    }
    
    private func setUnit() -> String {
        if let market = currentState.market {
            if market == "Upbit" || market == "Bithumb" {
                return "KRW"
            } else {
                return "USDT"
            }
        }
        return ""
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
        
        if resultText.count > 9 {
            resultText = String(resultText.prefix(9))
            
            if resultText.last == "." {
                resultText.removeLast()
            }
        }
        
        return formatPrice(resultText)
    }
    
    private func calculateSetPrice(currentPrice: String, index: Int) -> String {
        guard let priceValue = Double(currentPrice) else {
            return ""
        }
        
        let newValue = String(priceValue * (1 + Double(index) / 100.0)).prefix(10)
        return String(newValue)
    }
    
    func formatPrice(_ price: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        if let number = Double(price.replacingOccurrences(of: ",", with: "")) {
            return numberFormatter.string(from: NSNumber(value: number)) ?? price
        }
        
        return price
    }
}
