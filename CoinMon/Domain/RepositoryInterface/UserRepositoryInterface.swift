import RxSwift

protocol UserRepositoryInterface {
    func withdraw() -> Observable<UserDTO>
    func changeNickname(nickname: String) -> Observable<UserDTO>
    func fetchUserData() -> Observable<UserResponseDTO>
}
