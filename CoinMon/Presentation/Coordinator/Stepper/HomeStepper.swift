import RxFlow
import RxCocoa

class HomeStepper: Stepper {
    var steps = PublishRelay<Step>()
    var initialStep: Step

    init(initialStep: Step = HomeStep.navigateToHomeViewController) {
        self.initialStep = initialStep
        self.steps.accept(initialStep)
    }

    func resetFlow() {
        self.steps.accept(HomeStep.endFlow)
    }
}
