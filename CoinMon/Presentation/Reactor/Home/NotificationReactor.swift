import ReactorKit
import RxCocoa
import RxFlow
import UserNotifications

class NotificationReactor: ReactorKit.Reactor, Stepper {
    var initialState: State = State()
    var steps = PublishRelay<Step>()
    private let alarmUseCase: AlarmUseCase
    
    init(alarmUseCase: AlarmUseCase){
        self.alarmUseCase = alarmUseCase
    }
    
    enum Action {
        case backButtonTapped
        case alarmSettingButtonTapped
        case upButtonTapped
        case selectItem(Int)
        case loadNotifications
        case checkNotificationStatus
        case scrollViewDidScroll(CGPoint)
    }
    
    enum Mutation {
        case setNotifications([NotificationAlert])
        case setNotificationStatus(Bool)
        case scrollToTop
        case setScrollPosition(CGPoint)
    }
    
    struct State {
        var isNotificationEnabled: Bool = true
        var notificationTypes: [String] = [
            LocalizationManager.shared.localizedString(forKey: "전체"),
            LocalizationManager.shared.localizedString(forKey: "지표 알림"),
            LocalizationManager.shared.localizedString(forKey: "지정가 알림"),
        ]
        var notifications: [NotificationAlert] = []
        var isScrolledToTop: Bool = true
        var scrollPosition: CGPoint = .zero
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonTapped:
            self.steps.accept(HomeStep.popViewController)
            return .empty()
        case .alarmSettingButtonTapped:
            self.steps.accept(HomeStep.goToAlarmSetting)
            return .empty()
        case .upButtonTapped:
            return .just(.scrollToTop)
        case .selectItem(let index):
            return alarmUseCase.fetchNotificationList()
                .flatMap { notificationList -> Observable<Mutation> in
                    var notiList: [NotificationAlert] = notificationList
                    if index == 0 {
                        
                    } 
                    else if index == 1 {
                        notiList = notiList.filter {
                            $0.type == "IB" || $0.type == "IS"
                        }
                    } 
                    else {
                        notiList = notiList.filter {
                            $0.type == "T"
                        }
                    }
                    print(notiList)
                    return .just(.setNotifications(notiList))
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: HomeStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .loadNotifications:
            return alarmUseCase.fetchNotificationList()
                .flatMap { notificationList -> Observable<Mutation> in
                    return .just(.setNotifications(notificationList))
                }
                .catch { [weak self] error in
                    ErrorHandler.handle(error) { (step: HomeStep) in
                        self?.steps.accept(step)
                    }
                    return .empty()
                }
        case .checkNotificationStatus:
            return checkNotificationStatus()
        case .scrollViewDidScroll(let contentOffset):
            return .just(.setScrollPosition(contentOffset))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setNotificationStatus(let isEnabled):
            newState.isNotificationEnabled = isEnabled
        case .setNotifications(let notifications):
            newState.notifications = notifications
        case .scrollToTop:
            newState.isScrolledToTop = !currentState.isScrolledToTop
        case .setScrollPosition(let contentOffset):
            newState.scrollPosition = contentOffset
        }
        return newState
    }
    
    private func checkNotificationStatus() -> Observable<Mutation> {
        return Observable.create { observer in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    observer.onNext(.setNotificationStatus(true))
                default:
                    observer.onNext(.setNotificationStatus(false))
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
