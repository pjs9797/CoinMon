import RxSwift
@testable import CoinMon

class MockSigninRepository: SigninRepositoryInterface {
    var checkEmailIsExistedResult: Observable<SigninDTO>!
    var requestEmailVerificationCodeResult: Observable<SigninDTO>!
    var checkEmailVerificationCodeForLoginResult: Observable<SigninResponseDTO>!
    
    func checkEmailIsExisted(email: String) -> Observable<SigninDTO> {
        return checkEmailIsExistedResult
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<SigninDTO> {
        return requestEmailVerificationCodeResult
    }
    
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<SigninResponseDTO> {
        return checkEmailVerificationCodeForLoginResult
    }
}
