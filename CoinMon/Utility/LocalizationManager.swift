import Foundation
import RxCocoa

class LocalizationManager {
    static let shared = LocalizationManager()
    var language: String = ""
    var rxLanguage: BehaviorRelay<String> = BehaviorRelay<String>(value: "ko")
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "appLanguage") {
            language = savedLanguage
            rxLanguage = BehaviorRelay<String>(value: savedLanguage)
        } else if let appLanguage = Bundle.main.preferredLocalizations.first {
            language = appLanguage
            rxLanguage = BehaviorRelay<String>(value: appLanguage)
        }
    }
    
    func setLanguage(_ newLanguage: String) {
        language = newLanguage
        rxLanguage.accept(newLanguage)
        UserDefaults.standard.set(newLanguage, forKey: "appLanguage")
    }
    
    func localizedString(forKey key: String, arguments: CVarArg...) -> String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? ""
        return String(format: format, arguments: arguments)
    }
}
