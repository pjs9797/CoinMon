import Moya
import RxMoya
import RxSwift

class SignupRepository: SignupRepositoryInterface {
    private let provider = MoyaProvider<SignupService>()
    
    func checkEmailDuplication(email: String) -> Observable<SignupDTO> {
        return provider.rx.request(.checkEmail(email: email))
            .filterSuccessfulStatusCodes()
            .map(SignupDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func requestEmailVerificationCode(email: String) -> Observable<SignupDTO> {
        return provider.rx.request(.emailCode(email: email))
            .filterSuccessfulStatusCodes()
            .map(SignupDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func checkEmailVerificationCode(email: String, number: String) -> Observable<SignupDTO> {
        return provider.rx.request(.checkEmailCode(email: email, number: number))
            .filterSuccessfulStatusCodes()
            .map(SignupDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func requestPhoneVerificationCode(phoneNumber: String) -> Observable<SignupDTO> {
        return provider.rx.request(.phoneCode(phoneNumber: phoneNumber))
            .filterSuccessfulStatusCodes()
            .map(SignupDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func checkPhoneVerificationCode(phoneNumber: String, number: String) -> Observable<SignupDTO> {
        return provider.rx.request(.checkPhoneCode(phoneNumber: phoneNumber, number: number))
            .filterSuccessfulStatusCodes()
            .map(SignupDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func signup(phoneNumber: String, email: String, userType: String) -> Observable<SignupDTO> {
        return provider.rx.request(.signup(phoneNumber: phoneNumber, email: email, userType: userType))
            .filterSuccessfulStatusCodes()
            .map(SignupDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
}
