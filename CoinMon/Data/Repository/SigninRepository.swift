import Moya
import RxMoya
import RxSwift

class SigninRepository: SigninRepositoryInterface {
    private var provider = MoyaProvider<SigninService>()
    
    init(provider: MoyaProvider<SigninService> = MoyaProvider<SigninService>()) {
        self.provider = provider
    }
    
    func checkEmailIsExisted(email: String) -> Observable<SigninDTO> {
        return provider.rx.request(.checkEmail(email: email))
            .filterSuccessfulStatusCodes()
            .map(SigninDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<SigninDTO> {
        return provider.rx.request(.loginCode(email: email))
            .filterSuccessfulStatusCodes()
            .map(SigninDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<SigninResponseDTO> {
        return provider.rx.request(.login(email: email, number: number, deviceToken: deviceToken))
            .filterSuccessfulStatusCodes()
            .map(SigninResponseDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
