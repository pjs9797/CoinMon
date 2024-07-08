import RxSwift

class SignupUseCase {
    private let repository: SignupRepositoryInterface

    init(repository: SignupRepositoryInterface) {
        self.repository = repository
    }
    
    func checkEmailDuplication(email: String) -> Observable<String> {
        return repository.checkEmailDuplication(email: email)
            .map { SignupTranslator.toResultCode(dto: $0) }
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<String> {
        return repository.requestEmailVerificationCode(email: email)
            .map { SignupTranslator.toResultCode(dto: $0) }
    }
    
    func checkEmailVerificationCode(email: String, number: String) -> Observable<String> {
        return repository.checkEmailVerificationCode(email: email, number: number)
            .map { SignupTranslator.toResultCode(dto: $0) }
    }
    
    func requestPhoneVerificationCode(phoneNumber: String) -> Observable<String> {
        return repository.requestPhoneVerificationCode(phoneNumber: phoneNumber)
            .map { SignupTranslator.toResultCode(dto: $0) }
    }
    
    func checkPhoneVerificationCode(phoneNumber: String, number: String) -> Observable<String> {
        return repository.checkPhoneVerificationCode(phoneNumber: phoneNumber, number: number)
            .map { SignupTranslator.toResultCode(dto: $0) }
    }
    
    func signup(phoneNumber: String, email: String, userType: String) -> Observable<String> {
        return repository.signup(phoneNumber: phoneNumber, email: email, userType: userType)
            .map { SignupTranslator.toResultCode(dto: $0) }
    }
}
