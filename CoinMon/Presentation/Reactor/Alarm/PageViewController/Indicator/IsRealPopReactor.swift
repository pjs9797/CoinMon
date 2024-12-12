import ReactorKit
import Foundation
import RxCocoa
import RxFlow

class IsRealPopReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    private let flowType: FlowType
    
    init(flowType: FlowType) {
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
            if flowType == .purchase {
                self.steps.accept(PurchaseStep.dismiss)
            }
            else {
                self.steps.accept(AlarmStep.dismissSheetPresentationController)
            }
            return .empty()
        case .outButtonTapped:
            if flowType == .purchase {
                NotificationCenter.default.post(name: .isOutSelectCoinAtPremium, object: nil)
                self.steps.accept(PurchaseStep.dismiss)
                self.steps.accept(PurchaseStep.popToRootViewController)
            }
            else {
                NotificationCenter.default.post(name: .isOutSelectCoinAtPremium, object: nil)
                self.steps.accept(AlarmStep.dismissSheetPresentationController)
                self.steps.accept(AlarmStep.popViewController)
            }
            return .empty()
        }
    }
}
