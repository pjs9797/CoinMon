import Moya
import RxMoya
import RxSwift

class SigninRepository: SigninRepositoryInterface {
    private let provider = MoyaProvider<SigninService>()
    
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
    
    func checkEmailVerificationCodeForLogin(email: String, number: String, deviceToken: String) -> Observable<String> {
        return provider.rx.request(.login(email: email, number: number, deviceToken: deviceToken))
            .filterSuccessfulStatusCodes()
            .map(SigninDTO.self)
            .map{ SigninDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
