import Foundation

struct ConfigManager {
    static var kakaoNativeAppKey: String {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        
        guard let kakaoKey = infoDictionary["KAKAO_NATIVE_APP_KEY"] as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY not found in Info.plist")
        }
        return kakaoKey
    }
    
    static var serverBaseURL: String {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        
        guard let baseURL = infoDictionary["SERVER_BASE_URL"] as? String else {
            fatalError("SERVER_BASE_URL not found in Info.plist")
        }
        return baseURL
    }
}
