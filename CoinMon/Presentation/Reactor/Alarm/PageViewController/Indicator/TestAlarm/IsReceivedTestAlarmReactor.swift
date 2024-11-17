import ReactorKit
import UIKit
import RxCocoa
import RxFlow
import Foundation

class IsReceivedTestAlarmReactor: ReactorKit.Reactor, Stepper {
    let initialState: State = State()
    var steps = PublishRelay<Step>()
    
    enum Action {
        case isNotReceivedButtonTapped
        case isReceivedButtonTapped
    }
    
    enum Mutation {
    }
    
    struct State {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .isNotReceivedButtonTapped:
            let isRegistered = UIApplication.shared.isRegisteredForRemoteNotifications
            if isRegistered {
                self.steps.accept(AlarmStep.dismissSheetPresentationController)
                self.steps.accept(AlarmStep.presentToResendTestAlarmViewController)
            } 
            else {
                self.steps.accept(AlarmStep.dismissSheetPresentationController)
                self.steps.accept(AlarmStep.presentToIsNotSetTestAlarmViewController)
            }
            return .empty()
        case .isReceivedButtonTapped:
            NotificationCenter.default.post(name: .receiveTestAlarm, object: nil)
            self.steps.accept(AlarmStep.dismissSheetPresentationController)
            return .empty()
        }
    }
}
