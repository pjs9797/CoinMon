import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class IsRealPopReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let flowType: IsRealPopFlowType
    
    init(flowType: IsRealPopFlowType) {
        self.flowType = flowType
    }
    
    enum Action {
        case continueButtonTapped
        case outButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .continueButtonTapped:
            if flowType == .atPurchase {
                self.steps.accept(PurchaseStep.dismiss)
            }
            else {
                self.steps.accept(AlarmStep.dismissSheetPresentationController)
            }
            return .empty()
        case .outButtonTapped:
            if flowType == .atPurchase {
                NotificationCenter.default.post(name: .isOutSelectCoinAtPremium, object: nil)
                self.steps.accept(PurchaseStep.dismiss)
                self.steps.accept(PurchaseStep.popViewController)
            }
            else {
                self.steps.accept(AlarmStep.dismissSheetPresentationController)
                self.steps.accept(AlarmStep.popViewController)
            }
            return .empty()
        }
    }
}
