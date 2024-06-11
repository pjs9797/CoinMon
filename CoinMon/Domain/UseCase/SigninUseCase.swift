import RxSwift
import Foundation

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
            .flatMap { response -> Observable<String> in
                if response.resultCode == "200" {
                    TokenManager.shared.saveAccessToken(response.accessToken)
                    TokenManager.shared.saveRefreshToken(response.refreshToken)
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }
                return .just(response.resultCode)
            }
    }
}
