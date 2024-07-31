import Moya
import Foundation
import RxMoya
import RxSwift

class SigninRepository: SigninRepositoryInterface {
    private var provider = MoyaProvider<SigninService>()
    
    init(provider: MoyaProvider<SigninService> = MoyaProvider<SigninService>()) {
        self.provider = provider
    }
    
    func checkEmailIsExisted(email: String) -> Observable<String> {
        return provider.rx.request(.checkEmail(email: email))
            .filterSuccessfulStatusCodes()
            .map(SigninDTO.self)
            .map{ SigninDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<String> {
        return provider.rx.request(.loginCode(email: email))
            .filterSuccessfulStatusCodes()
            .map(SigninDTO.self)
            .map{ SigninDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<AuthTokens?> {
        return provider.rx.request(.login(email: email, number: number, deviceToken: deviceToken))
            .filterSuccessfulStatusCodes()
            .map(SigninResponseDTO.self)
            .map{ SigninResponseDTO.toAuthTokens(dto: $0)}
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}

class MockSigninRepository: SigninRepositoryInterface {
    var shouldReturnError = false
    var emailExists = true
    
    func checkEmailIsExisted(email: String) -> Observable<String> {
        if shouldReturnError {
            return Observable.error(NSError(domain: "Network Error", code: -1, userInfo: nil))
        } else {
            if emailExists {
                return Observable.just("200")
            } else {
                return Observable.just("400")
            }
        }
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<String> {
        // Implement similar logic for other methods if needed
        return Observable.just("200")
    }
    
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<AuthTokens?> {
        // Implement similar logic for other methods if needed
        return Observable.just(nil)
    }
}
