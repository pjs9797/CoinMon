import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class SelectCycleForIndicatorReactor: ReactorKit.Reactor, Stepper {
    let initialState: State
    var steps = PublishRelay<Step>()
    private let indicatorUseCase: IndicatorUseCase
    private let flowType: SelectCycleForIndicatorFlowType
    private let selectCoinForIndicatorFlowType: SelectCoinForIndicatorFlowType
    
    init(indicatorUseCase: IndicatorUseCase, flowType: SelectCycleForIndicatorFlowType, selectCoinForIndicatorFlowType: SelectCoinForIndicatorFlowType, indicatorId: String, frequency: String, targets: [String], indicatorName: String, isPremium: Bool) {
        self.initialState = State(indicatorId: indicatorId, frequency: frequency, targets: targets, indicatorName: indicatorName, isPremium: isPremium)
        self.indicatorUseCase = indicatorUseCase
        self.flowType = flowType
        self.selectCoinForIndicatorFlowType = selectCoinForIndicatorFlowType
    }
    
    enum Action {
        case backButtonTapped
        case completeButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
        var indicatorId: String
        var frequency: String
        var targets: [String]
        var indicatorName: String
        var isPremium: Bool
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            if selectCoinForIndicatorFlowType == .atPurchase {
                self.steps.accept(PurchaseStep.popViewController)
            }
            else {
                if flowType == .atMain {
                    self.steps.accept(AlarmStep.popToRootViewController)
                }
                else {
                    self.steps.accept(AlarmStep.popViewController)
                }
            }
            return .empty()
        case .completeButtonTapped:
            return self.indicatorUseCase.createIndicatorPush(indicatorId: currentState.indicatorId, frequency: currentState.frequency, targets: currentState.targets)
                .flatMap { [weak self] resultCode -> Observable<Mutation> in
                    if resultCode == "200" {
                        let indicatorId = self?.currentState.indicatorId
                        let indicatorName = self?.currentState.indicatorName
                        let isPremium = self?.currentState.isPremium
                        let frequency = self?.currentState.frequency
                        if isPremium ?? true {
                            UserDefaultsManager.shared.saveNotSetAlarmTooltipHidden(true)
                            NotificationCenter.default.post(name: .isCompletedSelectCoinAtPremium, object: nil)
                        }
                        self?.steps.accept(AlarmStep.navigateToDetailIndicatorViewController(flowType: "WhenCreate", indicatorId: indicatorId!, indicatorName: indicatorName!, isPremium: isPremium!, frequency: frequency!))
                    }
                    return .empty()
                }
                .catch { [weak self] error in
                    if self?.selectCoinForIndicatorFlowType == .atPurchase {
                        ErrorHandler.handle(error) { (step: PurchaseStep) in
                            self?.steps.accept(step)
                        }
                    }
                    else {
                        ErrorHandler.handle(error) { (step: AlarmStep) in
                            self?.steps.accept(step)
                        }
                    }
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        }
        return newState
    }
}
