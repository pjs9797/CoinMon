import UIKit
import KakaoSDKCommon
import FirebaseMessaging
import FirebaseCore
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: ConfigManager.kakaoNativeAppKey)
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("FCM 토큰: \(fcmToken)")
        TokenManager.shared.saveFCMToken(fcmToken)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("deviceToken",tokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // 백그라운드에서 알림 데이터 처리
        print("Remote notification received: \(userInfo)")
        NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil)
        UserDefaults.standard.setValue(true, forKey: "didReceiveNotificationAtBackground")
        if application.applicationState == .background || application.applicationState == .inactive {
            print("App is in background or inactive state")
            incrementBadgeCount()
        } else {
            print("App is in active state")
        }
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 포그라운드에 있을 때 알림 표시 옵션 설정
        print("Will present notification: \(notification.request.content.userInfo)")
        NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil)
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 알림에 대한 사용자 반응 처리
        print("Did receive notification response: \(response.notification.request.content.userInfo)")
        NotificationCenter.default.post(name: Notification.Name("didReceiveRemoteNotification"), object: nil)
        completionHandler()
    }
    
    private func incrementBadgeCount() {
        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
        print("currentBadgeCount",currentBadgeCount)
        UIApplication.shared.applicationIconBadgeNumber = currentBadgeCount + 1
    }
}
