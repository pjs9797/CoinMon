import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Moya
import Foundation
@testable import CoinMon

class SigninRepositorySpec: QuickSpec {
    override class func spec() {
        var provider: MoyaProvider<SigninService>!
        var repository: SigninRepository!
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
        
        describe("SigninRepository") {
            beforeEach {
                provider = MoyaProvider<SigninService>(stubClosure: MoyaProvider.immediatelyStub)
                repository = SigninRepository(provider: provider)
            }
            
            afterEach {
                provider = nil
                repository = nil
            }
            
            context("이메일 존재 여부 요청") {
                context("이메일이 존재하는 경우") {
                    it("200을 반환하지 않는다") {
                        let email = "test@gmail.com"
                        let result = try? repository.checkEmailIsExisted(email: email).toBlocking().single()
                        
                        expect(result).toNot(equal("200"))
                    }
                }
                
                context("이메일이 존재하지 않는 경우") {
                    it("200을 반환한다") {
                        let email = "1234@gmail.com"
                        let result = try? repository.checkEmailIsExisted(email: email).toBlocking().single()
                        
                        expect(result).to(equal("200"))
                    }
                }
                
                context("네트워크 오류 발생 시") {
                    beforeEach {
                        provider = MoyaProvider<SigninService>(endpointClosure: networkErrorEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
                        repository = SigninRepository(provider: provider)
                    }
                    
                    it("결과가 nil이다") {
                        let email = "test@gmail.com"
                        let result = try? repository.checkEmailIsExisted(email: email).toBlocking().single()
                        
                        expect(result).to(beNil())
                    }
                }
            }
            
            context("이메일 인증 코드 요청") {
                context("인증 코드 요청이 성공하는 경우") {
                    it("200을 반환한다") {
                        let email = "test@gmail.com"
                        let result = try? repository.requestEmailVerificationCode(email: email).toBlocking().single()
                        
                        expect(result).to(equal("200"))
                    }
                }
                
                context("네트워크 오류 발생 시") {
                    beforeEach {
                        provider = MoyaProvider<SigninService>(endpointClosure: networkErrorEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
                        repository = SigninRepository(provider: provider)
                    }
                    
                    it("결과가 nil이다") {
                        let email = "test@gmail.com"
                        let result = try? repository.requestEmailVerificationCode(email: email).toBlocking().single()
                        
                        expect(result).to(beNil())
                    }
                }
            }
            
            context("로그인 이메일 인증 코드 확인") {
                context("로그인 인증 코드 확인이 성공하는 경우") {
                    it("200을 반환한다") {
                        let email = "test@gmail.com"
                        let number = "102030"
                        let deviceToken = "deviceToken"
                        let result = try? repository.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
                        
                        expect(result?.resultCode).to(equal("200"))
                    }
                }
                
                context("로그인 인증 코드 확인이 실패하는 경우") {
                    it("200을 반환하지 않는다") {
                        let email = "test@gmail.com"
                        let number = "123456"
                        let deviceToken = "deviceToken"
                        let result = try? repository.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
                        
                        expect(result?.resultCode).toNot(equal("200"))
                    }
                }
                
                context("네트워크 오류 발생 시") {
                    beforeEach {
                        provider = MoyaProvider<SigninService>(endpointClosure: networkErrorEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
                        repository = SigninRepository(provider: provider)
                    }
                    
                    it("결과가 nil이다") {
                        let email = "test@gmail.com"
                        let number = "123456"
                        let deviceToken = "deviceToken"
                        let result = try? repository.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
                        
                        expect(result).to(beNil())
                    }
                }
            }
        }
    }
}
