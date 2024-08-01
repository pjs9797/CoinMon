import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import CoinMon

class SigninEmailEntryViewControllerSpec: QuickSpec {
    override class func spec() {
        var viewController: SigninEmailEntryViewController!
        var reactor: SigninEmailEntryReactor!
        var signinRepository: MockSigninRepository!
        var signinUseCase: SigninUseCase!

        describe("SigninEmailEntryViewController") {
            beforeEach {
                signinRepository = MockSigninRepository()
                signinUseCase = SigninUseCase(repository: signinRepository)
                reactor = SigninEmailEntryReactor(signinUseCase: signinUseCase)
                viewController = SigninEmailEntryViewController(with: reactor)
                //viewController.loadViewIfNeeded()
            }

            afterEach {
                viewController = nil
                reactor = nil
                signinRepository = nil
                signinUseCase = nil
            }

            context("유효한 이메일 입력 시") {
                beforeEach {
                    let validEmail = "test@gmail.com"
                    reactor.action.onNext(.updateEmail(validEmail))
                }

                it("다음 버튼이 활성화된다") {
                    let nextButton = viewController.signinEmailEntryView.nextButton
                    
                    expect(nextButton.isEnabled).to(beTrue())
                    expect(nextButton.backgroundColor).to(equal(ColorManager.orange_60))
                }
            }

            context("유효하지 않은 이메일 입력 시") {
                beforeEach {
                    let invalidEmail = "invalid-email"
                    reactor.action.onNext(.updateEmail(invalidEmail))
                }

                it("에러 라벨이 표시된다") {
                    let errorLabel = viewController.signinEmailEntryView.emailErrorLabel
                    
                    expect(errorLabel.isHidden).to(beFalse())
                }

                it("다음 버튼이 비활성화된다") {
                    let nextButton = viewController.signinEmailEntryView.nextButton
                    
                    expect(nextButton.isEnabled).to(beFalse())
                    expect(nextButton.backgroundColor).to(equal(ColorManager.gray_90))
                }
            }

            context("이메일 입력 시") {
                beforeEach {
                    let email = "test@gmail.com"
                    reactor.action.onNext(.updateEmail(email))
                }

                it("클리어 버튼이 표시된다") {
                    let clearButton = viewController.signinEmailEntryView.clearButton
                    
                    expect(clearButton.isHidden).to(beFalse())
                }
            }
        }
    }
}
