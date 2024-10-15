import RxFlow
import RxCocoa

class AlarmStepper: Stepper {
    var steps = PublishRelay<Step>()
    var initialStep: Step

    init(initialStep: Step = AlarmStep.navigateToMainAlarmViewController) {
        self.initialStep = initialStep
        self.steps.accept(initialStep)
    }
    
    func resetFlow() {
        self.steps.accept(AlarmStep.endFlow)
    }
}
