class UserCredentialsManager {
    static let shared = UserCredentialsManager()
    
    private init(){}
    
    var email: String = ""
    var phoneNumber: String = ""
}
