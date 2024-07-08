import RxSwift
import Foundation

class SigninUseCase {
    private let repository: SigninRepositoryInterface

    init(repository: SigninRepositoryInterface) {
        self.repository = repository
    }
    
    func checkEmailIsExisted(email: String) -> Observable<String> {
        return repository.checkEmailIsExisted(email: email)
            .map { SigninTranslator.toResultCode(dto: $0) }
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<String> {
        return repository.requestEmailVerificationCode(email: email)
            .map { SigninTranslator.toResultCode(dto: $0) }
    }
    
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<String> {
        return repository.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken)
            .map { SigninTranslator.toAuthTokens(dto: $0) }
            .flatMap { response -> Observable<String> in
                if let response = response, response.resultCode == "200" {
                    TokenManager.shared.saveAccessToken(response.accessToken)
                    TokenManager.shared.saveRefreshToken(response.refreshToken)
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }
                return .just(response?.resultCode ?? "426")
            }
    }
}
