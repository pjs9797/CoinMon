import ReactorKit
import RxCocoa
import RxFlow
import UserNotifications

class NotificationReactor: ReactorKit.Reactor, Stepper {
    var initialState: State = State()
    var steps = PublishRelay<Step>()
    
    init(notificationCenter: UNUserNotificationCenter = .current()) {
        notificationCenter.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self?.initialState = State(isNotificationEnabled: true)
            default:
                self?.initialState = State(isNotificationEnabled: false)
            }
        }
    }
    
    enum Action {
        case backButtonTapped
        case alarmSettingButtonTapped
        case loadNotifications
    }
    
    enum Mutation {
        case setNotifications([NotificationAlert])
    }
    
    struct State {
        var isNotificationEnabled: Bool = true
        var notifications: [NotificationAlert] = [
            
        ]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(HomeStep.popViewController)
            return .empty()
        case .alarmSettingButtonTapped:
            self.steps.accept(HomeStep.goToAlarmSetting)
            return .empty()
        case .loadNotifications:
            return .just(.setNotifications(self.currentState.notifications))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNotifications(let notifications):
            newState.notifications = notifications
        }
        return newState
    }
}
