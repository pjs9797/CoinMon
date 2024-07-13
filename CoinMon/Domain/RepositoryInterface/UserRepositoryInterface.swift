import RxSwift

protocol UserRepositoryInterface {
    func withdraw() -> Observable<String>
    func changeNickname(nickname: String) -> Observable<String>
    func fetchUserData() -> Observable<UserData>
}
