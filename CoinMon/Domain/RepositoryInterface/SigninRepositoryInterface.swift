import RxSwift

protocol SigninRepositoryInterface {
    func checkEmailIsExisted(email: String) -> Observable<String>
    func requestEmailVerificationCode(email: String) -> Observable<String>
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<String>
}
