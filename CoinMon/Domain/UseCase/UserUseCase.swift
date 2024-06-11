import RxSwift
import Foundation

class UserUseCase {
    private let repository: UserRepositoryInterface

    init(repository: UserRepositoryInterface) {
        self.repository = repository
    }
    
    func withdraw() -> Observable<String> {
        return repository.withdraw()
    }
    
    func changeNickname(nickname: String) -> Observable<String> {
        return repository.changeNickname(nickname: nickname)
    }
    
    func fetchUserData() -> Observable<UserData> {
        return repository.fetchUserData()
    }
}
