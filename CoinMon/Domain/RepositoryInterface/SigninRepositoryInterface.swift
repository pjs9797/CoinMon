import RxSwift

protocol SigninRepositoryInterface {
    func checkEmailIsExisted(email: String) -> Observable<SigninDTO>
    func requestEmailVerificationCode(email: String) -> Observable<SigninDTO>
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<SigninResponseDTO>
}
