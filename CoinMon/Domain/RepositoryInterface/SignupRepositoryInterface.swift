import RxSwift

protocol SignupRepositoryInterface {
    func checkEmailDuplication(email: String) -> Observable<String>
    func requestEmailVerificationCode(email: String) -> Observable<String>
    func checkEmailVerificationCode(email: String, number: String) -> Observable<String>
    func signup(email: String, userType: String) -> Observable<String>
}
