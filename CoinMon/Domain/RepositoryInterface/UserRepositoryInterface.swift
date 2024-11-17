import RxSwift

protocol UserRepositoryInterface {
    func logout() -> Observable<String>
    func withdraw() -> Observable<String>
    func appleWithdraw(authorizationCode: String) -> Observable<String>
    func changeNickname(nickname: String) -> Observable<String>
    func fetchUserData() -> Observable<UserData>
}
