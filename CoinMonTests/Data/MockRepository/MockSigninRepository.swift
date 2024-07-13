import RxSwift
@testable import CoinMon

class MockSigninRepository: SigninRepositoryInterface {
    var checkEmailIsExistedResult: Observable<String>!
    var requestEmailVerificationCodeResult: Observable<String>!
    var checkEmailVerificationCodeForLoginResult: Observable<AuthTokens?>!
    
    func checkEmailIsExisted(email: String) -> Observable<String> {
        return checkEmailIsExistedResult
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<String> {
        return requestEmailVerificationCodeResult
    }
    
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<AuthTokens?> {
        return checkEmailVerificationCodeForLoginResult
    }
}
