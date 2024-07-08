import RxSwift

protocol SignupRepositoryInterface {
    func checkEmailDuplication(email: String) -> Observable<SignupDTO>
    func requestEmailVerificationCode(email: String) -> Observable<SignupDTO>
    func checkEmailVerificationCode(email: String, number: String) -> Observable<SignupDTO>
    func requestPhoneVerificationCode(phoneNumber: String) -> Observable<SignupDTO>
    func checkPhoneVerificationCode(phoneNumber: String, number: String) -> Observable<SignupDTO>
    func signup(phoneNumber: String, email: String, userType: String) -> Observable<SignupDTO>
}
