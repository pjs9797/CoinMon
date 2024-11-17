import Foundation

enum LoginType: String {
    case coinmon
    case apple
    case kakao
    case none
}

enum SubscriptionStatus: String {
    case normal
    case trial
    case subscription
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let isFirstLaunchKey = "IsFirstLaunchKey"
    
    private let isLoggedInKey = "isLoggedIn"
    private let loginTypeKey = "loginType"
    
    private let subscriptionStatusKey = "UserSubscriptionStatusKey"
    private let trialUseKey = "TrialUseKey"
    
    private let newIndicatorHiddenKey = "NewIndicatorHiddenKey"
    private let trialTooltipHiddenKey = "TrialTooltipHiddenTimeKey"
    private let notSetAlarmTooltipHiddenKey = "NotSetAlarmTooltipHiddenKey"
    
    private init() {
        if UserDefaults.standard.object(forKey: isFirstLaunchKey) == nil {
            UserDefaults.standard.set(true, forKey: isFirstLaunchKey)
        }
        if UserDefaults.standard.object(forKey: trialTooltipHiddenKey) == nil {
            UserDefaults.standard.set(true, forKey: trialTooltipHiddenKey)
        }
        if UserDefaults.standard.object(forKey: notSetAlarmTooltipHiddenKey) == nil {
            UserDefaults.standard.set(true, forKey: notSetAlarmTooltipHiddenKey)
        }
    }
    
    // 앱 첫 실행 여부 저장
    func setIsFirstLaunch(_ isFirstLaunch: Bool) {
        UserDefaults.standard.set(isFirstLaunch, forKey: isFirstLaunchKey)
    }
    
    // 앱 첫 실행 여부 확인
    func getIsFirstLaunch() -> Bool {
        return UserDefaults.standard.bool(forKey: isFirstLaunchKey)
    }
    
    // 로그인 상태 저장
    func setLoggedIn(_ loggedIn: Bool, loginType: LoginType = .none) {
        UserDefaults.standard.set(loggedIn, forKey: isLoggedInKey)
        if loggedIn {
            UserDefaults.standard.set(loginType.rawValue, forKey: loginTypeKey)
        } else {
            UserDefaults.standard.removeObject(forKey: loginTypeKey)
        }
    }
    
    // 로그인 여부 확인
    func getIsLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    // 로그인 타입 확인
    func getLoginType() -> LoginType {
        guard getIsLoggedIn() else {
            return .none
        }
        
        if let loginTypeString = UserDefaults.standard.string(forKey: loginTypeKey) {
            return LoginType(rawValue: loginTypeString) ?? .none
        }
        return .none
    }
    
    // NewIndicator 숨김 시간을 저장합니다.
    func saveNewIndicatorHiddenTime(_ date: Date) {
        UserDefaults.standard.set(date, forKey: newIndicatorHiddenKey)
    }
    
    // NewIndicator 숨김 시간을 가져옵니다.
    func getNewIndicatorHiddenTime() -> Date? {
        return UserDefaults.standard.object(forKey: newIndicatorHiddenKey) as? Date
    }
    
    // Trial Tooltip 숨김 시간을 저장합니다.
    func saveTrialTooltipHiddenTime(_ date: Date) {
        UserDefaults.standard.set(date, forKey: trialTooltipHiddenKey)
    }
    
    // Trial Tooltip 숨김 시간을 가져옵니다.
    func getTrialTooltipHiddenTime() -> Date? {
        return UserDefaults.standard.object(forKey: trialTooltipHiddenKey) as? Date
    }
    
    // 알람 설정 완료 여부를 저장합니다.
    func saveNotSetAlarmTooltipHidden(_ isHidden: Bool) {
        UserDefaults.standard.set(isHidden, forKey: notSetAlarmTooltipHiddenKey)
    }
    
    // 알람 설정 완료 여부를 가져옵니다.
    func getIsNotSetAlarmTooltipHidden() -> Bool {
        return UserDefaults.standard.bool(forKey: notSetAlarmTooltipHiddenKey)
    }
}
