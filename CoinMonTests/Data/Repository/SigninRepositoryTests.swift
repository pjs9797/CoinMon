import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Nimble
import Moya
@testable import CoinMon

class SigninRepositoryTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var provider: MoyaProvider<SigninService>!
    var repository: SigninRepository!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        provider = MoyaProvider<SigninService>(stubClosure: MoyaProvider.immediatelyStub)
        repository = SigninRepository(provider: provider)
    }
    
    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        provider = nil
        repository = nil
        super.tearDown()
    }
    
    func test_checkEmailIsExisted_이메일_존재_여부_요청_존재() {
        // Given
        let email = "test@gmail.com"
        
        // When
        let result = try? repository.checkEmailIsExisted(email: email).toBlocking().single()
        
        // Then
        expect(result?.resultCode).toNot(equal("200"))
    }
    
    func test_checkEmailIsExisted_이메일_존재_여부_요청_존재하지_않음() {
        // Given
        let email = "1234@gmail.com"
        
        // When
        let result = try? repository.checkEmailIsExisted(email: email).toBlocking().single()
        
        // Then
        expect(result?.resultCode).to(equal("200"))
    }
    
    func test_checkEmailIsExisted_이메일_존재_여부_요청_네트워크_에러() {
        // Given
        provider = MoyaProvider<SigninService>(endpointClosure: networkErrorEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        repository = SigninRepository(provider: provider)
        let email = "test@gmail.com"
        
        // When
        let result = try? repository.checkEmailIsExisted(email: email).toBlocking().single()
        
        // Then
        expect(result).to(beNil())
    }
    
    func test_requestEmailVerificationCode_이메일_인증_코드_요청_성공() {
        // Given
        let email = "test@gmail.com"
        
        // When
        let result = try? repository.requestEmailVerificationCode(email: email).toBlocking().single()
        
        // Then
        expect(result?.resultCode).to(equal("200"))
    }
    
    func test_requestEmailVerificationCode_이메일_인증_코드_요청_네트워크_에러() {
        // Given
        provider = MoyaProvider<SigninService>(endpointClosure: networkErrorEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        repository = SigninRepository(provider: provider)
        let email = "test@gmail.com"
        
        // When
        let result = try? repository.requestEmailVerificationCode(email: email).toBlocking().single()
        
        // Then
        expect(result).to(beNil())
    }
    
    func test_checkEmailVerificationCodeForLogin_로그인_이메일_인증_코드_요청_성공() {
        // Given
        let email = "test@gmail.com"
        let number = "102030"
        let deviceToken = "deviceToken"
        
        // When
        let result = try? repository.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
        
        // Then
        expect(result?.resultCode).to(equal("200"))
    }
    
    func test_checkEmailVerificationCodeForLogin_로그인_이메일_인증_코드_요청_실패() {
        // Given
        let email = "test@gmail.com"
        let number = "123456"
        let deviceToken = "deviceToken"
        
        // When
        let result = try? repository.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
        
        // Then
        expect(result?.resultCode).toNot(equal("200"))
    }
    
    func test_checkEmailVerificationCodeForLogin_로그인_이메일_인증_코드_네트워크_에러() {
        // Given
        provider = MoyaProvider<SigninService>(endpointClosure: networkErrorEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        repository = SigninRepository(provider: provider)
        let email = "test@gmail.com"
        let number = "123456"
        let deviceToken = "deviceToken"
        
        // When
        let result = try? repository.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
        
        // Then
        expect(result).to(beNil())
    }
    
    let networkErrorEndpointClosure = { (target: SigninService) -> Endpoint in
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: {
                .networkError(NSError(domain: "NetworkError", code: -1, userInfo: nil))
            },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }
}
