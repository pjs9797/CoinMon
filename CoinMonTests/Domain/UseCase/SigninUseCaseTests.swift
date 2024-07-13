import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Nimble
@testable import CoinMon

class SigninUseCaseTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var repository: MockSigninRepository!
    var useCase: SigninUseCase!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        repository = MockSigninRepository()
        useCase = SigninUseCase(repository: repository)
    }
    
    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        repository = nil
        useCase = nil
        super.tearDown()
    }
    
    func test_checkEmailIsExisted_이메일_존재_여부() {
        // Given
        let email = "test@gmail.com"
        repository.checkEmailIsExistedResult = .just("200")
        
        // When
        let result = try! useCase.checkEmailIsExisted(email: email).toBlocking().single()
        
        // Then
        expect(result).to(equal("200"))
    }
    
    func test_checkEmailIsExisted_이메일_존재_여부_실패() {
        // Given
        let email = "test@gmail.com"
        repository.checkEmailIsExistedResult = .error(NSError(domain: "Network Error", code: -1, userInfo: nil))
        
        // When
        let result = try? useCase.checkEmailIsExisted(email: email).toBlocking().single()
        
        // Then
        expect(result).to(beNil())
    }
    
    func test_requestEmailVerificationCode_이메일_인증_코드_요청() {
        // Given
        let email = "test@gmail.com"
        repository.requestEmailVerificationCodeResult = .just("200")
        
        // When
        let result = try! useCase.requestEmailVerificationCode(email: email).toBlocking().single()
        
        // Then
        expect(result).to(equal("200"))
    }
    
    func test_requestEmailVerificationCode_이메일_인증_코드_요청_실패() {
        // Given
        let email = "test@gmail.com"
        repository.requestEmailVerificationCodeResult = .error(NSError(domain: "Network Error", code: -1, userInfo: nil))
        
        // When
        let result = try? useCase.requestEmailVerificationCode(email: email).toBlocking().single()
        
        // Then
        expect(result).to(beNil())
    }
    
    func test_checkEmailVerificationCodeForLogin_로그인_이메일_인증_코드_확인() {
        // Given
        let email = "test@gmail.com"
        let number = "102030"
        let deviceToken = "deviceToken"
        repository.checkEmailVerificationCodeForLoginResult = .just(AuthTokens(resultCode: "200", accessToken: "accessToken", refreshToken: "refreshToken"))
        
        // When
        let result = try! useCase.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
        
        // Then
        expect(result).to(equal("200"))
    }
    
    func test_checkEmailVerificationCodeForLogin_로그인_이메일_인증_코드_확인_실패() {
        // Given
        let email = "test@gmail.com"
        let number = "123456"
        let deviceToken = "deviceToken"
        repository.checkEmailVerificationCodeForLoginResult = .error(NSError(domain: "Network Error", code: -1, userInfo: nil))
        
        // When
        let result = try? useCase.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
        
        // Then
        expect(result).to(beNil())
    }
}
