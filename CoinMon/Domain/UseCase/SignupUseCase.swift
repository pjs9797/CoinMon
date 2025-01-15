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
    
    func signup(email: String, userType: String) -> Observable<String> {
        return repository.signup(email: email, userType: userType)
    }
}
