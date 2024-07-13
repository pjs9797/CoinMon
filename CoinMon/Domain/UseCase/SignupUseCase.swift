import RxSwift

class SignupUseCase {
    private let repository: SignupRepositoryInterface

    init(repository: SignupRepositoryInterface) {
        self.repository = repository
    }
    
    func checkEmailDuplication(email: String) -> Observable<String> {
        return repository.checkEmailDuplication(email: email)
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<String> {
        return repository.requestEmailVerificationCode(email: email)
    }
    
    func checkEmailVerificationCode(email: String, number: String) -> Observable<String> {
        return repository.checkEmailVerificationCode(email: email, number: number)
    }
    
    func requestPhoneVerificationCode(phoneNumber: String) -> Observable<String> {
        return repository.requestPhoneVerificationCode(phoneNumber: phoneNumber)
    }
    
    func checkPhoneVerificationCode(phoneNumber: String, number: String) -> Observable<String> {
        return repository.checkPhoneVerificationCode(phoneNumber: phoneNumber, number: number)
    }
    
    func signup(phoneNumber: String, email: String, userType: String) -> Observable<String> {
        return repository.signup(phoneNumber: phoneNumber, email: email, userType: userType)
    }
}
