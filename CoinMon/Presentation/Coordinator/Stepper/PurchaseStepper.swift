import RxFlow
import RxCocoa

class PurchaseStepper: Stepper {
    var steps = PublishRelay<Step>()
    var initialStep: Step

    init(initialStep: Step = PurchaseStep.navigateToPurchaseViewController) {
        self.initialStep = initialStep
        self.steps.accept(initialStep)
    }

    func resetFlow() {
        self.steps.accept(PurchaseStep.endFlow)
    }
}
