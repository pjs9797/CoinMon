import Quick
import Nimble
import RxSwift
import RxTest
import Foundation
@testable import CoinMon

class SigninEmailEntryReactorSpec: QuickSpec {
    override class func spec() {
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var reactor: SigninEmailEntryReactor!
        var signinRepository: MockSigninRepository!
        var signinUseCase: SigninUseCase!
        
        describe("SigninEmailEntryReactor") {
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                signinRepository = MockSigninRepository()
                signinUseCase = SigninUseCase(repository: signinRepository)
                reactor = SigninEmailEntryReactor(signinUseCase: signinUseCase)
            }
            
            afterEach {
                scheduler = nil
                disposeBag = nil
                reactor = nil
                signinRepository = nil
                signinUseCase = nil
            }
            
            context("유효한 이메일 입력 시") {
                beforeEach {
                    let validEmail = "test@gmail.com"
                    reactor.action.onNext(.updateEmail(validEmail))
                }
                
                it("이메일이 업데이트되고 유효한 상태가 된다") {
                    let expectedState = SigninEmailEntryReactor.State(email: "test@gmail.com", isEmailValid: true, isClearButtonHidden: false)
                    
                    expect(reactor.currentState.email).to(equal(expectedState.email))
                    expect(reactor.currentState.isEmailValid).to(equal(expectedState.isEmailValid))
                    expect(reactor.currentState.isClearButtonHidden).to(equal(expectedState.isClearButtonHidden))
                }
            }
            
            context("유효하지 않은 이메일 입력 시") {
                beforeEach {
                    let invalidEmail = "invalid-email"
                    reactor.action.onNext(.updateEmail(invalidEmail))
                }
                
                it("이메일이 업데이트되고 유효하지 않은 상태가 된다") {
                    let expectedState = SigninEmailEntryReactor.State(email: "invalid-email", isEmailValid: false, isClearButtonHidden: false)
                    
                    expect(reactor.currentState.email).to(equal(expectedState.email))
                    expect(reactor.currentState.isEmailValid).to(equal(expectedState.isEmailValid))
                    expect(reactor.currentState.isClearButtonHidden).to(equal(expectedState.isClearButtonHidden))
                }
            }
            
            context("클리어 버튼 탭 시") {
                beforeEach {
                    reactor.action.onNext(.clearButtonTapped)
                }
                
                it("이메일이 지워지고 클리어 버튼이 숨겨진다") {
                    let expectedState = SigninEmailEntryReactor.State(email: "", isEmailValid: false, isClearButtonHidden: true)
                    
                    expect(reactor.currentState.email).to(equal(expectedState.email))
                    expect(reactor.currentState.isEmailValid).to(equal(expectedState.isEmailValid))
                    expect(reactor.currentState.isClearButtonHidden).to(equal(expectedState.isClearButtonHidden))
                }
            }
            
            context("다음 버튼 탭 시") {
                context("이메일이 존재하지 않으면") {
                    beforeEach {
                        let email = "aaa@gmail.com"
                        reactor.action.onNext(.updateEmail(email))
                        signinRepository.checkEmailIsExistedResult = Observable.just("200")
                    }
                    
                    it("NoRegisteredEmailErrorAlertController를 표시한다") {
                        let expectedStep: SigninStep = .presentToNoRegisteredEmailErrorAlertController
                        
                        let stepObserver = scheduler.createObserver(SigninStep.self)
                        reactor.steps
                            .compactMap { $0 as? SigninStep }
                            .subscribe(stepObserver)
                            .disposed(by: disposeBag)
                        
                        reactor.action.onNext(.nextButtonTapped)
                        scheduler.start()
                        
                        let lastStep = stepObserver.events
                        expect(lastStep.last?.value.element).toEventually(equal(expectedStep))
                    }
                }
                
                context("이메일이 존재하면") {
                    beforeEach {
                        let email = "test@gmail.com"
                        reactor.action.onNext(.updateEmail(email))
                        signinRepository.checkEmailIsExistedResult = Observable.just("400")
                        reactor.action.onNext(.nextButtonTapped)
                    }
                    
                    it("SigninEmailVerificationNumberViewController로 이동한다") {
                        let expectedStep: SigninStep = .navigateToSigninEmailVerificationNumberViewController
                        
                        let stepObserver = scheduler.createObserver(SigninStep.self)
                        reactor.steps
                            .compactMap { $0 as? SigninStep }
                            .subscribe(stepObserver)
                            .disposed(by: disposeBag)
                        
                        reactor.action.onNext(.nextButtonTapped)
                        scheduler.start()
                        
                        let lastStep = stepObserver.events
                        expect(lastStep.last?.value.element).toEventually(equal(expectedStep))
                    }
                }
                
                context("네트워크 오류 발생 시") {
                    beforeEach {
                        let email = "test@gmail.com"
                        reactor.action.onNext(.updateEmail(email))
                        signinRepository.checkEmailIsExistedResult = Observable.error(NSError(domain: "NetworkError", code: -1, userInfo: nil))
                        reactor.action.onNext(.nextButtonTapped)
                    }
                    
                    it("NetworkErrorAlertController를 표시한다") {
                        let expectedStep: SigninStep = .presentToNetworkErrorAlertController
                        
                        let stepObserver = scheduler.createObserver(SigninStep.self)
                        reactor.steps
                            .compactMap { $0 as? SigninStep }
                            .subscribe(stepObserver)
                            .disposed(by: disposeBag)
                        
                        reactor.action.onNext(.nextButtonTapped)
                        scheduler.start()
                        
                        let lastStep = stepObserver.events
                        expect(lastStep.last?.value.element).toEventually(equal(expectedStep))
                    }
                }
            }
        }
    }
}
