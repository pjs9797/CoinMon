import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Foundation
@testable import CoinMon

class SigninUseCaseSpec: QuickSpec {
    override class func spec() {
        var repository: MockSigninRepository!
        var useCase: SigninUseCase!
        
        describe("SigninUseCase") {
            beforeEach {
                repository = MockSigninRepository()
                useCase = SigninUseCase(repository: repository)
            }
            
            afterEach {
                repository = nil
                useCase = nil
            }
            
            context("이메일 존재 여부 확인") {
                context("이메일이 존재하는 경우") {
                    beforeEach {
                        repository.checkEmailIsExistedResult = .just("400")
                    }
                    
                    it("200을 반환하지 않는다") {
                        let email = "test@gmail.com"
                        let result = try! useCase.checkEmailIsExisted(email: email).toBlocking().single()
                        
                        expect(result).toNot(equal("200"))
                    }
                }
                
                context("이메일이 존재하지 않는 경우") {
                    beforeEach {
                        repository.checkEmailIsExistedResult = .just("200")
                    }
                    
                    it("200을 반환한다") {
                        let email = "nonexistent@gmail.com"
                        let result = try? useCase.checkEmailIsExisted(email: email).toBlocking().single()
                        
                        expect(result).to(equal("200"))
                    }
                }
            }
            
            context("이메일 인증 코드 요청") {
                context("인증 코드 요청이 성공하는 경우") {
                    beforeEach {
                        repository.requestEmailVerificationCodeResult = .just("200")
                    }
                    
                    it("200을 반환한다") {
                        let email = "test@gmail.com"
                        let result = try! useCase.requestEmailVerificationCode(email: email).toBlocking().single()
                        
                        expect(result).to(equal("200"))
                    }
                }
                
                context("인증 코드 요청이 실패하는 경우") {
                    beforeEach {
                        repository.requestEmailVerificationCodeResult = .error(NSError(domain: "Network Error", code: -1, userInfo: nil))
                    }
                    
                    it("결과가 nil이다") {
                        let email = "test@gmail.com"
                        let result = try? useCase.requestEmailVerificationCode(email: email).toBlocking().single()
                        
                        expect(result).to(beNil())
                    }
                }
            }
            
            context("로그인 이메일 인증 코드 확인") {
                context("로그인 인증 코드 확인이 성공하는 경우") {
                    beforeEach {
                        repository.checkEmailVerificationCodeForLoginResult = .just(AuthTokens(resultCode: "200", accessToken: "accessToken", refreshToken: "refreshToken"))
                    }
                    
                    it("200을 반환한다") {
                        let email = "test@gmail.com"
                        let number = "102030"
                        let deviceToken = "deviceToken"
                        let result = try! useCase.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
                        
                        expect(result).to(equal("200"))
                    }
                }
                
                context("로그인 인증 코드 확인이 실패하는 경우") {
                    beforeEach {
                        repository.checkEmailVerificationCodeForLoginResult = .just(AuthTokens(resultCode: "400", accessToken: "", refreshToken: ""))
                    }
                    
                    it("200을 반환하지 않는다") {
                        let email = "test@gmail.com"
                        let number = "123456"
                        let deviceToken = "deviceToken"
                        let result = try? useCase.checkEmailVerificationCodeForLogin(email: email, number: number, deviceToken: deviceToken).toBlocking().single()
                        
                        expect(result).toNot(equal("200"))
                    }
                }
            }
        }
    }
}
