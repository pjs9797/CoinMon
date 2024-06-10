import RxSwift

class SigninUseCase {
    private let repository: SigninRepositoryInterface

    init(repository: SigninRepositoryInterface) {
        self.repository = repository
    }
    
    func checkEmailIsExisted(email: String) -> Observable<String> {
        return repository.checkEmailIsExisted(email: email)
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<String> {
        return repository.requestEmailVerificationCode(email: email)
    }
    
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<String> {
        return repository.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken)
    }
}
