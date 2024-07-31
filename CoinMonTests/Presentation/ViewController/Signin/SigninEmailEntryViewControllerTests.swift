import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Nimble
@testable import CoinMon

class SigninEmailEntryViewControllerTests: XCTestCase {
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var viewController: SigninEmailEntryViewController!
    var reactor: SigninEmailEntryReactor!
    var signinRepository: MockSigninRepository!
    var signinUseCase: SigninUseCase!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        signinRepository = MockSigninRepository()
        signinUseCase = SigninUseCase(repository: signinRepository)
        reactor = SigninEmailEntryReactor(signinUseCase: signinUseCase)
        viewController = SigninEmailEntryViewController(with: reactor)
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        viewController = nil
        reactor = nil
        signinRepository = nil
        signinUseCase = nil
        super.tearDown()
    }
    
    func test_이메일_입력시_다음버튼_활성화() {
        // Given
        let validEmail = "test@gmail.com"
        
        // When
        reactor.action.onNext(.updateEmail(validEmail))
        
        // Then
        let nextButton = viewController.signinEmailEntryView.nextButton
        expect(nextButton.isEnabled).to(beTrue())
        expect(nextButton.backgroundColor).to(equal(ColorManager.orange_60))
    }
    
    func test_유효하지_않은_이메일_입력시_에러라벨_표시() {
        // Given
        let invalidEmail = "invalid-email"
        
        // When
        reactor.action.onNext(.updateEmail(invalidEmail))
        
        // Then
        let errorLabel = viewController.signinEmailEntryView.emailErrorLabel
        let nextButton = viewController.signinEmailEntryView.nextButton
        expect(errorLabel.isHidden).to(beFalse())
        expect(nextButton.isEnabled).to(beFalse())
        expect(nextButton.backgroundColor).to(equal(ColorManager.gray_90))
    }
    
    func test_이메일_입력시_클리어버튼_표시() {
        // Given
        let email = "test@gmail.com"
        
        // When
        reactor.action.onNext(.updateEmail(email))
        
        // Then
        let clearButton = viewController.signinEmailEntryView.clearButton
        expect(clearButton.isHidden).to(beFalse())
    }
}
