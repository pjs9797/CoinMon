import ReactorKit
import RxCocoa
import RxFlow

class DetailIndicatorReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    
    init(indicatorUseCase: IndicatorUseCase, flowType: String, indicatorId: String, indicatorName: String, isPremium: Bool, frequency: String) {
        self.initialState = State(flowType: flowType, indicatorId: indicatorId, indicatorName: indicatorName, isPremium: isPremium, frequency: frequency)
        self.indicatorUseCase = indicatorUseCase
    }
    
    enum Action {
        case backButtonTapped
        case alarmCenterButtonTapped
        case settingButtonTapped
        case receiveTestAlarmButtonTapped
        case explainButtonTapped(indicatorId: String)
        case rightButtonTapped(indicatorId: String, indicatorCoinId: String, coin: String, price: String)
        case loadIndicatorCoinDatas
    }
    
    enum Mutation {
        case setIndicatorCoinDatas([IndicatorCoinData])
    }
    
    struct State {
        var flowType: String
        var indicatorId: String
        var indicatorName: String
        var isPremium: Bool
        var frequency: String
        var indicatorCoinDatas: [IndicatorCoinData] = []
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            if currentState.flowType == "WhenNotCreate" {
                self.steps.accept(AlarmStep.popViewController)
            }
            else {
                self.steps.accept(AlarmStep.popToRootViewController)
            }
            return .empty()
        case .alarmCenterButtonTapped:
            self.steps.accept(AlarmStep.goToAlarmSetting)
            return .empty()
        case .settingButtonTapped:
            self.steps.accept(AlarmStep.navigateToUpdateIndicatorCoinViewController(indicatorId: currentState.indicatorId, indicatorName: currentState.indicatorName, frequency: currentState.frequency))
            return .empty()
        case .receiveTestAlarmButtonTapped:
            //TODO: 테스트 알람 API 추가
            self.steps.accept(AlarmStep.presentToIsReceivedTestAlarmViewController)
            return .empty()
        case .explainButtonTapped(let indicatorId):
            self.steps.accept(AlarmStep.presentToExplainIndicatorSheetPresentationController(indicatorId: indicatorId))
            return .empty()
        case .rightButtonTapped(let indicatorId, let indicatorCoinId, let coin, let price):
            self.steps.accept(AlarmStep.navigateToDetailIndicatorCoinViewController(indicatorId: indicatorId, indicatorCoinId: indicatorCoinId, coin: coin, price: price, indicatorName: currentState.indicatorName, frequency: currentState.frequency))
            return .empty()
        case .loadIndicatorCoinDatas:
            return indicatorUseCase.getIndicatorCoinDataDetail(indicatorId: currentState.indicatorId)
                .flatMap { indicatorCoinData -> Observable<Mutation> in
                    return .just(.setIndicatorCoinDatas(indicatorCoinData))
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIndicatorCoinDatas(let indicatorCoinDatas):
            newState.indicatorCoinDatas = indicatorCoinDatas
        }
        return newState
    }
}
