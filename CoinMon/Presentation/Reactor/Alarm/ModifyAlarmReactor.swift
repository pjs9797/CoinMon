//import ReactorKit
//import RxCocoa
//import RxFlow
//
//class ModifyAlarmReactor: ReactorKit.Reactor, Stepper {
//    let initialState: State
//    var steps = PublishRelay<Step>()
//    private let alarmUseCase: AlarmUseCase
//    
//    init(alarmUseCase: AlarmUseCase, market: String, alarm: Alarm){
//        self.alarmUseCase = alarmUseCase
//        
//        let unit = market == "Upbit" || market == "Bithumb" ? "KRW" : "USDT"
//        
//        initialState = State(market: market, coinTitle: alarm.coinTitle, currentPriceUnit: unit, currentPrice: alarm)
//    }
//    
//    enum Action {
//        case backButtonTapped
//        case deleteButtonTapped
//        case marketButtonTapped
//        case coinButtonTapped
//        case comparePriceButtonTapped
//        case cycleButtonTapped
//        case completeButtonTapped
//        
//        case setMarket(String)
//        case setCoin(String,String)
//        case updateSetPrice(String)
//        case setComparePrice(Int)
//        case setCycle(String)
//    }
//    
//    enum Mutation {
//        case setMarket(String)
//        case setCoinTitle(String)
//        case setCurrentPriceUnit(String)
//        case setCurrentPrice(String)
//        case setSetPriceUnit(String)
//        case setSetPrice(String)
//        case setComparePrice(Int)
//        case setCycle(String)
//        case setCycleForAPI(String)
//    }
//    
//    struct State {
//        var market: String
//        var coinTitle: String
//        var currentPriceUnit: String
//        var currentPrice: String
//        var setPriceUnit: String
//        var setPrice: String
//        var comparePrice: Int? = nil
//        var cycle: String
//        var cycleForAPI: String = "0"
//        var isCompleteButtonEnable: Bool = false
//        
//    }
//    
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .backButtonTapped:
//            self.steps.accept(AlarmStep.popViewController)
//            return .empty()
//        case .deleteButtonTapped:
//            return .empty()
//        case .marketButtonTapped:
//            self.steps.accept(AlarmStep.presentToSelectMarketViewController(selectedMarketRelay: selectMarketRelay))
//            return .empty()
//        case .coinButtonTapped:
//            self.steps.accept(AlarmStep.navigateToSelectCoinViewController(selectedCoinRelay: selectCoinRelay))
//            return .empty()
//        case .comparePriceButtonTapped:
//            self.steps.accept(AlarmStep.presentToSelectFirstAlarmConditionViewController(firstAlarmConditionRelay: selectFirstAlarmConditionRelay))
//            return .empty()
//        case .cycleButtonTapped:
//            self.steps.accept(AlarmStep.presentToSelectSecondAlarmConditionViewController(secondAlarmConditionRelay: selectSecondAlarmConditionRelay))
//            return .empty()
//        case .completeButtonTapped:
//            var filter = "UP"
//            if let currentPrice = Double(currentState.currentPrice ?? "0"), let setPrice = Double(currentState.setPrice ?? "0") {
//                if currentPrice > setPrice {
//                    filter = "DOWN"
//                }
//            }
//            return alarmUseCase.createAlarm(exchange: currentState.market ?? "", symbol: currentState.coinTitle ?? "", targetPrice: currentState.setPrice ?? "", frequency: currentState.cycleForAPI, useYn: "Y", filter: filter)
//                .flatMap { [weak self] _ -> Observable<Mutation> in
//                    self?.steps.accept(AlarmStep.popViewController)
//                    return .empty()
//                }
//                .catch { [weak self] _ in
//                    self?.steps.accept(AlarmStep.presentToNetworkErrorAlertController)
//                    return .empty()
//                }
//        case .setMarket(let market):
//            return .just(.setMarket(market))
//        case .setCoin(let coin, let price):
//            let unit = setUnit()
//            return .concat([
//                .just(.setCoinTitle(coin)),
//                .just(.setCurrentPriceUnit(unit)),
//                .just(.setCurrentPrice(price)),
//                .just(.setSetPriceUnit(unit)),
//                .just(.setSetPrice(price)),
//            ])
//        case .updateSetPrice(let price):
//            if price == "" {
//                return .empty()
//            }
//            let filteredPrice = filterAndTruncatePrice(price: price)
//            return .concat([
//                .just(.setSetPrice(filteredPrice))
//            ])
//        case .setComparePrice(let index):
//            if let currentPrice = currentState.currentPrice{
//                let newPrice = calculateNewPrice(currentPrice: currentPrice, index: index)
//                return .concat([
//                    .just(.setComparePrice(index)),
//                    .just(.setSetPrice(newPrice))
//                ])
//            } else {
//                return .empty()
//            }
//        case .setCycle(let condition):
//            var cycleForAPI = "0"
//            switch condition {
//            case LocalizationManager.shared.localizedString(forKey: "한 번만"):
//                cycleForAPI = "0"
//            case LocalizationManager.shared.localizedString(forKey: "1분 간격"):
//                cycleForAPI = "1"
//            case LocalizationManager.shared.localizedString(forKey: "5분 간격"):
//                cycleForAPI = "5"
//            case LocalizationManager.shared.localizedString(forKey: "10분 간격"):
//                cycleForAPI = "10"
//            case LocalizationManager.shared.localizedString(forKey: "30분 간격"):
//                cycleForAPI = "30"
//            case LocalizationManager.shared.localizedString(forKey: "1시간 간격"):
//                cycleForAPI = "60"
//            default:
//                cycleForAPI = "0"
//            }
//            return .concat([
//                .just(.setCycle(condition)),
//                .just(.setCycleForAPI(cycleForAPI))
//            ])
//        }
//    }
//    
//    func reduce(state: State, mutation: Mutation) -> State {
//        var newState = state
//        switch mutation {
//        case .setMarket(let market):
//            newState.market = market
//        case .setCoinTitle(let coinTitle):
//            newState.coinTitle = coinTitle
//        case .setCurrentPriceUnit(let unit):
//            newState.currentPriceUnit = unit
//        case .setCurrentPrice(let currentPrice):
//            newState.currentPrice = currentPrice
//        case .setSetPriceUnit(let unit):
//            newState.setPriceUnit = unit
//        case .setSetPrice(let setPrice):
//            newState.setPrice = setPrice
//        case .setComparePrice(let comparePrice):
//            newState.comparePrice = comparePrice
//        case .setCycle(let cycle):
//            newState.cycle = cycle
//        case .setCycleForAPI(let cycleForAPI):
//            newState.cycleForAPI = cycleForAPI
//        }
//        newState.isCompleteButtonEnable = (newState.market != nil) && (newState.currentPrice != nil) && (newState.setPrice != nil) && (newState.cycle != nil)
//        return newState
//    }
//    
//    private func setUnit() -> String {
//        if let market = currentState.market {
//            if market == "Upbit" || market == "Bithumb" {
//                return "KRW"
//            } else {
//                return "USDT"
//            }
//        }
//        return ""
//    }
//    
//    private func filterAndTruncatePrice(price: String) -> String {
//        let filteredText = price.filter { $0.isNumber || $0 == "." }
//        var resultText = ""
//        var decimalFound = false
//        
//        for char in filteredText {
//            if char == "." {
//                if decimalFound {
//                    continue
//                } else {
//                    decimalFound = true
//                }
//            }
//            resultText.append(char)
//        }
//        
//        if resultText.count > 9 {
//            resultText = String(resultText.prefix(9))
//        }
//        
//        return resultText
//    }
//    
//    private func calculateNewPrice(currentPrice: String, index: Int) -> String {
//        guard let priceValue = Double(currentPrice) else {
//            return ""
//        }
//        
//        let newValue = String(priceValue * (1 + Double(index) / 100.0)).prefix(9)
//        return String(newValue)
//    }
//}
