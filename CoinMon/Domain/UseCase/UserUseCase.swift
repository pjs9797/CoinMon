import RxSwift

class UserUseCase {
    private let repository: UserRepositoryInterface

    init(repository: UserRepositoryInterface) {
        self.repository = repository
    }
    
    func logout() -> Observable<String> {
        return repository.logout()
    }
    
    func withdraw() -> Observable<String> {
        return repository.withdraw()
    }
    
    func appleWithdraw(authorizationCode: String) -> Observable<String> {
        return repository.appleWithdraw(authorizationCode: authorizationCode)
    }
    
    func changeNickname(nickname: String) -> Observable<String> {
        return repository.changeNickname(nickname: nickname)
    }
    
    func fetchUserData() -> Observable<UserData> {
        return repository.fetchUserData()
    }
    
    func checkRefresh() -> Observable<String> {
        return repository.checkRefresh()
            .flatMap { response -> Observable<String> in
                if let response = response, response.resultCode == "200" {
                    TokenManager.shared.saveAccessToken(response.accessToken)
                    TokenManager.shared.saveRefreshToken(response.refreshToken)
                }
                return .just(response?.resultCode ?? "426")
            }
    }
    
    func postSurvey(answer: String) -> Observable<String> {
        return repository.postSurvey(answer: answer)
    }
}
