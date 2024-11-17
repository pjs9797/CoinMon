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
                if let response = response, response.resultCode == "200" {
                    TokenManager.shared.saveAccessToken(response.accessToken)
                    TokenManager.shared.saveRefreshToken(response.refreshToken)
                    UserDefaultsManager.shared.setLoggedIn(true, loginType: .coinmon)
                }
                return .just(response?.resultCode ?? "426")
            }
    }
    
    func appleLogin(identityToken: String, authorizationCode: String, deviceToken: String) -> Observable<Any> {
        return repository.appleLogin(identityToken: identityToken, authorizationCode: authorizationCode, deviceToken: deviceToken)
            .flatMap { response -> Observable<Any> in
                if let tokens = response as? AuthTokens {
                    TokenManager.shared.saveAccessToken(tokens.accessToken)
                    TokenManager.shared.saveRefreshToken(tokens.refreshToken)
                    UserDefaultsManager.shared.setLoggedIn(true, loginType: .apple)
                    return .just(tokens.resultCode)
                }
                else if let emailTuple = response as? (String, String) {
                    return .just(emailTuple)
                } 
                else if let resultCode = response as? String {
                    return .just(resultCode)
                } 
                else {
                    return .error(NSError(domain: "Invalid response type", code: -1, userInfo: nil))
                }
            }
            .catch { error in
                return Observable.error(error)
            }
    }
}
