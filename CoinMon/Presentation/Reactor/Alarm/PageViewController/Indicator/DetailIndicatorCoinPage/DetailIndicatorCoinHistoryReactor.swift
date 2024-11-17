import ReactorKit
import RxCocoa
import RxFlow
import Foundation

class DetailIndicatorCoinHistoryReactor: ReactorKit.Reactor, Stepper {
    private var timerDisposable: Disposable?
    let initialState: State
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    
    init(indicatorUseCase: IndicatorUseCase, indicatorId: String, indicatorCoinId: String) {
        self.initialState = State(indicatorId: indicatorId, indicatorCoinId: indicatorCoinId)
        self.indicatorUseCase = indicatorUseCase
    }
    
    enum Action {
        case changeTimingType(Int)
        
        case startTimer
        case stopTimer
    }
    
    enum Mutation {
        case setIndicatorCoinHistories([IndicatorCoinHistory])
        case setIsEmptyIndicatorCoinHistories(Bool)
        case setTimingType(Int)
    }
    
    struct State {
        var indicatorId: String
        var indicatorCoinId: String
        var indicatorCoinHistories: [IndicatorCoinHistory] = []
        var isEmptyIndicatorCoinHistories: Bool = true
        var timingType: Int = 0
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeTimingType(let type):
            return indicatorUseCase.getIndicatorCoinHistory(indicatorId: currentState.indicatorId, indicatorCoinId: currentState.indicatorCoinId)
                .flatMap { indicatorCoinHistories -> Observable<Mutation> in
                    let isEmpty = indicatorCoinHistories.isEmpty
                    var updatedindicatorCoinHistories = indicatorCoinHistories
                    if !updatedindicatorCoinHistories.isEmpty {
                        updatedindicatorCoinHistories.removeFirst()
                    }
                    if type == 0 {
                        
                    }
                    else if type == 1 {
                        updatedindicatorCoinHistories = updatedindicatorCoinHistories.filter { $0.timing == "매도" }
                    }
                    else {
                        updatedindicatorCoinHistories = updatedindicatorCoinHistories.filter { $0.timing == "매수" }
                    }
                    return .concat([
                        .just(.setIsEmptyIndicatorCoinHistories(isEmpty)),
                        .just(.setIndicatorCoinHistories(updatedindicatorCoinHistories)),
                        .just(.setTimingType(type))
                    ])
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: AlarmStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .startTimer:
            startTimer()
            return .empty()
        case .stopTimer:
            stopTimer()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIndicatorCoinHistories(let indicatorCoinHistories):
            newState.indicatorCoinHistories = indicatorCoinHistories
        case .setIsEmptyIndicatorCoinHistories(let isEmpty):
            newState.isEmptyIndicatorCoinHistories = isEmpty
        case .setTimingType(let type):
            newState.timingType = type
        }
        return newState
    }
    
    private func startTimer() {
        stopTimer()
        timerDisposable = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                NotificationCenter.default.post(name: .refreshIndicatorHistory, object: nil)
                self?.action.onNext(.changeTimingType(self?.currentState.timingType ?? 0))
            })
    }
    
    private func stopTimer() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
}
