import Moya
import RxMoya
import RxSwift

class UserRepository: UserRepositoryInterface {
    private let provider = MoyaProvider<UserService>()
    
    func withdraw() -> Observable<UserDTO> {
        return provider.rx.request(.withdraw)
            .filterSuccessfulStatusCodes()
            .map(UserDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func changeNickname(nickname: String) -> Observable<UserDTO> {
        return provider.rx.request(.changeNickname(nickname: nickname))
            .filterSuccessfulStatusCodes()
            .map(UserDTO.self)
            .asObservable()
            .catch { error in
                return Observable.error(error)
            }
    }
    
    func fetchUserData() -> Observable<UserResponseDTO> {
        return provider.rx.request(.getUserData)
            .filterSuccessfulStatusCodes()
            .map(UserResponseDTO.self)
            .asObservable()
            .catch { error in
                if let moyaError = error as? MoyaError, let response = moyaError.response {
                    print("Error: \(moyaError), Status code: \(response.statusCode)")
                }
                return Observable.error(error)
            }
    }
}
