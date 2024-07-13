import Moya
import RxMoya
import RxSwift

class UserRepository: UserRepositoryInterface {
    private var provider = MoyaProvider<UserService>()
    
    init(provider: MoyaProvider<UserService> = MoyaProvider<UserService>()) {
        self.provider = provider
    }
    
    func withdraw() -> Observable<String> {
        return provider.rx.request(.withdraw)
            .filterSuccessfulStatusCodes()
            .map(UserDTO.self)
            .map{ UserDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func changeNickname(nickname: String) -> Observable<String> {
        return provider.rx.request(.changeNickname(nickname: nickname))
            .filterSuccessfulStatusCodes()
            .map(UserDTO.self)
            .map{ UserDTO.toResultCode(dto: $0) }
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchUserData() -> Observable<UserData> {
        return provider.rx.request(.getUserData)
            .filterSuccessfulStatusCodes()
            .map(UserResponseDTO.self)
            .map{ UserResponseDTO.toUserData(dto: $0) }
            .asObservable()
            .catch { error in
                if let moyaError = error as? MoyaError, let response = moyaError.response {
                    print("Error: \(moyaError), Status code: \(response.statusCode)")
                }
                return Observable.error(error)
            }
    }
}
