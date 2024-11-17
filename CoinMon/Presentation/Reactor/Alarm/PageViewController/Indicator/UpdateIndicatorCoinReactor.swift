import ReactorKit
import RxCocoa
import RxFlow

class UpdateIndicatorCoinReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    let selectCoinRelay = BehaviorRelay<[UpdateSelectedIndicatorCoin]>(value: [])
    
    init(indicatorUseCase: IndicatorUseCase, indicatorId: String, indicatorName: String, frequency: String) {
        self.initialState = State(indicatorId: indicatorId, indicatorName: indicatorName, frequency: frequency)
        self.indicatorUseCase = indicatorUseCase
    }
    
    enum Action {
        case backButtonTapped
        case deleteAllButtonTapped
        case selectButtonTapped
        case saveButtonTapped
        case loadSelectCoinDatas([UpdateSelectedIndicatorCoin])
        case loadIndicatorCoinDatas
        case pinButtonTapped(Int)
        case deleteButtonTapped(Int)
    }
    
    enum Mutation {
        case setInitialIndicatorCoinDatas([UpdateSelectedIndicatorCoin])
        case setIndicatorCoinDatas([UpdateSelectedIndicatorCoin])
        case setSaveButtonEnabled(Bool)
    }
    
    struct State {
        var indicatorId: String
        var indicatorName: String
        var frequency: String
        var initialIndicatorCoinDatas: [UpdateSelectedIndicatorCoin] = []
        var indicatorCoinDatas: [UpdateSelectedIndicatorCoin] = []
        var saveButtonEnabled: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(AlarmStep.popViewController)
            return .empty()
        case .deleteAllButtonTapped:
            self.steps.accept(AlarmStep.presentToDeleteIndicatorPushSheetPresentationController(indicatorId: currentState.indicatorId, indicatorName: currentState.indicatorName, flowType: "DeleteAtUpdateIndicator"))
            return .empty()
        case .selectButtonTapped:
            selectCoinRelay.accept(currentState.indicatorCoinDatas)
            self.steps.accept(AlarmStep.navigateToSelectCoinForUpdateIndicatorViewController(indicatorId: currentState.indicatorId, indicatorName: currentState.indicatorName, isPremium: currentState.indicatorId == "1", selectCoinRelay: selectCoinRelay))
            return .empty()
        case .saveButtonTapped:
            let targets = currentState.indicatorCoinDatas.sorted { $0.isPinned ? true : ($1.isPinned ? false : $0.indicatorCoinId < $1.indicatorCoinId) }.map { String($0.indicatorCoinId) }
            print("targets",targets)
            return indicatorUseCase.updateIndicatorPush(indicatorId: currentState.indicatorId, frequency: currentState.frequency, targets: targets)
                .flatMap { resultCoid -> Observable<Mutation> in
                    if resultCoid == "200" {
                        print("저장 성공")
                        self.steps.accept(AlarmStep.popViewController)
                    }
                    return .empty()
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .loadSelectCoinDatas(let updateSelectedIndicatorCoin):
            var updatedIndicatorCoinDatas = updateSelectedIndicatorCoin
            if !updatedIndicatorCoinDatas.contains(where: { $0.isPinned }) && !updatedIndicatorCoinDatas.isEmpty {
                updatedIndicatorCoinDatas[0].isPinned = true
            }
            let isSaveButtonEnabled = updateSelectedIndicatorCoin != currentState.initialIndicatorCoinDatas
            return .concat([
                .just(.setIndicatorCoinDatas(updateSelectedIndicatorCoin)),
                .just(.setSaveButtonEnabled(isSaveButtonEnabled))
            ])
        case .loadIndicatorCoinDatas:
            return indicatorUseCase.getUpdateIndicatorCoinDataDetail(indicatorId: currentState.indicatorId)
                .flatMap { indicatorCoinData -> Observable<Mutation> in
                    print(indicatorCoinData)
                    return .concat([
                        .just(.setIndicatorCoinDatas(indicatorCoinData)),
                        .just(.setInitialIndicatorCoinDatas(indicatorCoinData))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .pinButtonTapped(let index):
            let updatedData = currentState.indicatorCoinDatas.enumerated().map { (i, data) in
                var newData = data
                newData.isPinned = (i == index)
                return newData
            }
            let isSaveButtonEnabled = updatedData != currentState.initialIndicatorCoinDatas
            return .concat([
                .just(.setIndicatorCoinDatas(updatedData)),
                .just(.setSaveButtonEnabled(isSaveButtonEnabled))
            ])
        case .deleteButtonTapped(let index):
            var updatedData = currentState.indicatorCoinDatas
            updatedData.remove(at: index)
            if !updatedData.isEmpty {
                updatedData[0].isPinned = true
            }
            let isSaveButtonEnabled = updatedData != currentState.initialIndicatorCoinDatas
            return .concat([
                .just(.setIndicatorCoinDatas(updatedData)),
                .just(.setSaveButtonEnabled(isSaveButtonEnabled))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIndicatorCoinDatas(let indicatorCoinDatas):
            var updatedIndicatorCoinDatas = indicatorCoinDatas
            if !updatedIndicatorCoinDatas.contains(where: { $0.isPinned }) && !updatedIndicatorCoinDatas.isEmpty {
                updatedIndicatorCoinDatas[0].isPinned = true
            }
            newState.indicatorCoinDatas = updatedIndicatorCoinDatas
        case .setSaveButtonEnabled(let isEnabled):
            newState.saveButtonEnabled = isEnabled
        case .setInitialIndicatorCoinDatas(let indicatorCoinDatas):
            newState.initialIndicatorCoinDatas = indicatorCoinDatas
        }
        return newState
    }
}
