import Moya
import Foundation
import RxMoya
import RxSwift

class SigninRepository: SigninRepositoryInterface {
    private let provider: MoyaProvider<SigninService>
    
    init() {
        provider = MoyaProvider<SigninService>(requestClosure: MoyaProviderUtils.requestClosure, session: Session(interceptor: MoyaRequestInterceptor()))
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
    
    func appleLogin(identityToken: String, authorizationCode: String, deviceToken: String) -> Observable<Any> {
        return provider.rx.request(.appleLogin(identityToken: identityToken, authorizationCode: authorizationCode, deviceToken: deviceToken))
            .filterSuccessfulStatusCodes()
            .map(AppleLoginResponseDTO.self)
            .map{ AppleLoginResponseDTO.toResponse(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
