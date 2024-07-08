import RxSwift

class UserUseCase {
    private let repository: UserRepositoryInterface

    init(repository: UserRepositoryInterface) {
        self.repository = repository
    }
    
    func withdraw() -> Observable<String> {
        return repository.withdraw()
            .map { UserTranslator.toResultCode(dto: $0) }
    }
    
    func changeNickname(nickname: String) -> Observable<String> {
        return repository.changeNickname(nickname: nickname)
            .map { UserTranslator.toResultCode(dto: $0) }
    }
    
    func fetchUserData() -> Observable<UserData> {
        return repository.fetchUserData()
            .map { UserTranslator.toUserData(dto: $0) }
    }
}
